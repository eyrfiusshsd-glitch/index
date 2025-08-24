import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/message_model.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  final String _conversationsCollection = 'conversations';
  final String _messagesCollection = 'messages';

  // Get conversations for a user
  Future<List<MessageModel>> getConversations(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_conversationsCollection)
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      List<MessageModel> conversations = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final otherUserId = (data['participants'] as List)
            .firstWhere((id) => id != userId);
        
        // Get other user info (in a real app, you'd fetch from users collection)
        conversations.add(MessageModel(
          id: doc.id,
          username: data['otherUserName'] ?? 'مستخدم',
          userAvatar: data['otherUserAvatar'] ?? 'https://picsum.photos/50/50?random=1',
          lastMessage: data['lastMessage'] ?? '',
          timestamp: _formatTimestamp(data['lastMessageTime']),
          isOnline: data['otherUserOnline'] ?? false,
          unreadCount: data['unreadCount_$userId'] ?? 0,
          isVerified: data['otherUserVerified'] ?? false,
        ));
      }
      
      return conversations;
    } catch (e) {
      // Return mock conversations if Firestore is not available
      return _getMockConversations();
    }
  }

  // Get messages for a conversation
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_messagesCollection)
          .where('conversationId', isEqualTo: conversationId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => ChatMessage.fromJson({...doc.data(), 'id': doc.id}))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      // Return mock messages if Firestore is not available
      return _getMockMessages();
    }
  }

  // Send message
  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType type,
    String? mediaUrl,
  }) async {
    try {
      // Add message to messages collection
      final messageData = {
        'conversationId': conversationId,
        'senderId': senderId,
        'receiverId': receiverId,
        'content': content,
        'type': type.toString(),
        'mediaUrl': mediaUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'isSent': true,
      };

      final messageDoc = await _firestore.collection(_messagesCollection).add(messageData);

      // Update conversation with last message
      await _updateConversation(
        conversationId: conversationId,
        lastMessage: content,
        senderId: senderId,
        receiverId: receiverId,
      );

      return messageDoc.id;
    } catch (e) {
      throw 'فشل في إرسال الرسالة: $e';
    }
  }

  // Create or get conversation
  Future<String> createOrGetConversation(String userId1, String userId2) async {
    try {
      // Check if conversation already exists
      final existingConversation = await _firestore
          .collection(_conversationsCollection)
          .where('participants', arrayContains: userId1)
          .get();

      for (var doc in existingConversation.docs) {
        final participants = List<String>.from(doc.data()['participants']);
        if (participants.contains(userId2)) {
          return doc.id;
        }
      }

      // Create new conversation
      final conversationData = {
        'participants': [userId1, userId2],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount_$userId1': 0,
        'unreadCount_$userId2': 0,
      };

      final conversationDoc = await _firestore
          .collection(_conversationsCollection)
          .add(conversationData);

      return conversationDoc.id;
    } catch (e) {
      throw 'فشل في إنشاء المحادثة: $e';
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_messagesCollection)
          .where('conversationId', isEqualTo: conversationId)
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      
      await batch.commit();

      // Reset unread count in conversation
      await _firestore.collection(_conversationsCollection).doc(conversationId).update({
        'unreadCount_$userId': 0,
      });
    } catch (e) {
      throw 'فشل في تحديث حالة القراءة: $e';
    }
  }

  // Upload media (image, video, audio)
  Future<String> uploadMedia(File file, MessageType type) async {
    try {
      String folder;
      String extension;
      
      switch (type) {
        case MessageType.image:
          folder = 'message_images';
          extension = '.jpg';
          break;
        case MessageType.video:
          folder = 'message_videos';
          extension = '.mp4';
          break;
        case MessageType.audio:
          folder = 'message_audios';
          extension = '.m4a';
          break;
        default:
          folder = 'message_files';
          extension = '';
      }

      final ref = _storage
          .ref()
          .child(folder)
          .child('${DateTime.now().millisecondsSinceEpoch}$extension');

      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw 'فشل في رفع الملف: $e';
    }
  }

  // Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection(_messagesCollection).doc(messageId).delete();
    } catch (e) {
      throw 'فشل في حذف الرسالة: $e';
    }
  }

  // Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      // Delete all messages in the conversation
      final messagesSnapshot = await _firestore
          .collection(_messagesCollection)
          .where('conversationId', isEqualTo: conversationId)
          .get();

      final batch = _firestore.batch();
      
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Delete the conversation
      batch.delete(_firestore.collection(_conversationsCollection).doc(conversationId));
      
      await batch.commit();
    } catch (e) {
      throw 'فشل في حذف المحادثة: $e';
    }
  }

  // Get message stream for real-time updates
  Stream<List<ChatMessage>> getMessageStream(String conversationId) {
    return _firestore
        .collection(_messagesCollection)
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson({...doc.data(), 'id': doc.id}))
            .toList()
            .reversed
            .toList());
  }

  // Private helper methods
  Future<void> _updateConversation({
    required String conversationId,
    required String lastMessage,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      await _firestore.collection(_conversationsCollection).doc(conversationId).update({
        'lastMessage': lastMessage,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount_$receiverId': FieldValue.increment(1),
      });
    } catch (e) {
      // Handle error silently for mock implementation
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'الآن';
    
    try {
      final DateTime dateTime = (timestamp as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}د';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}س';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}د';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return 'الآن';
    }
  }

  // Mock data methods
  List<MessageModel> _getMockConversations() {
    return [
      MessageModel(
        id: '1',
        username: 'AmjR',
        userAvatar: 'https://picsum.photos/50/50?random=1',
        lastMessage: 'مرحبا كيف حالك؟',
        timestamp: 'منذ 2 س',
        isOnline: true,
        unreadCount: 0,
        isVerified: false,
      ),
      MessageModel(
        id: '2',
        username: 'مخفف',
        userAvatar: 'https://picsum.photos/50/50?random=2',
        lastMessage: 'شكرا لك على المساعدة',
        timestamp: 'الآن',
        isOnline: false,
        unreadCount: 0,
        isVerified: false,
      ),
      MessageModel(
        id: '3',
        username: 'Afra',
        userAvatar: 'https://picsum.photos/50/50?random=3',
        lastMessage: 'تم إرسال الجمعة',
        timestamp: 'الجمعة',
        isOnline: false,
        unreadCount: 0,
        isVerified: true,
      ),
      MessageModel(
        id: '4',
        username: 'ajirlyiq',
        userAvatar: 'https://picsum.photos/50/50?random=4',
        lastMessage: 'كان نشطًا منذ ساعة',
        timestamp: 'منذ ساعة',
        isOnline: false,
        unreadCount: 0,
        isVerified: true,
      ),
      MessageModel(
        id: '5',
        username: 'Ahmad Aburob',
        userAvatar: 'https://picsum.photos/50/50?random=5',
        lastMessage: 'تم إرسال الأربعاء',
        timestamp: 'الأربعاء',
        isOnline: false,
        unreadCount: 0,
        isVerified: true,
      ),
      MessageModel(
        id: '6',
        username: 'super.sttore',
        userAvatar: 'https://picsum.photos/50/50?random=6',
        lastMessage: 'تم التفاعل باستخدام 😍 مع رسائلك في',
        timestamp: 'أمس',
        isOnline: false,
        unreadCount: 1,
        isVerified: true,
      ),
      MessageModel(
        id: '7',
        username: 'christo',
        userAvatar: 'https://picsum.photos/50/50?random=7',
        lastMessage: 'نشط اليوم',
        timestamp: 'اليوم',
        isOnline: false,
        unreadCount: 0,
        isVerified: false,
      ),
    ];
  }

  List<ChatMessage> _getMockMessages() {
    return [
      ChatMessage(
        id: '1',
        senderId: 'other',
        receiverId: 'me',
        content: 'مرحبا! كيف حالك؟',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        isSent: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'me',
        receiverId: 'other',
        content: 'أهلاً وسهلاً! بخير والحمد لله، وأنت كيف حالك؟',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
        isSent: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'other',
        receiverId: 'me',
        content: 'الحمد لله بخير، شكراً لسؤالك',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
        isSent: true,
      ),
      ChatMessage(
        id: '4',
        senderId: 'me',
        receiverId: 'other',
        content: 'هل تريد أن نتحدث عن شيء معين؟',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        isSent: true,
      ),
    ];
  }
}