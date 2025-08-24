class MessageModel {
  final String id;
  final String username;
  final String userAvatar;
  final String lastMessage;
  final String timestamp;
  final bool isOnline;
  final int unreadCount;
  final bool isVerified;
  final MessageType? messageType;

  MessageModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    required this.unreadCount,
    required this.isVerified,
    this.messageType,
  });

  MessageModel copyWith({
    String? id,
    String? username,
    String? userAvatar,
    String? lastMessage,
    String? timestamp,
    bool? isOnline,
    int? unreadCount,
    bool? isVerified,
    MessageType? messageType,
  }) {
    return MessageModel(
      id: id ?? this.id,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
      isVerified: isVerified ?? this.isVerified,
      messageType: messageType ?? this.messageType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatar': userAvatar,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'isOnline': isOnline,
      'unreadCount': unreadCount,
      'isVerified': isVerified,
      'messageType': messageType?.toString(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      lastMessage: json['lastMessage'],
      timestamp: json['timestamp'],
      isOnline: json['isOnline'],
      unreadCount: json['unreadCount'],
      isVerified: json['isVerified'],
      messageType: json['messageType'] != null 
          ? MessageType.values.firstWhere(
              (e) => e.toString() == json['messageType'],
              orElse: () => MessageType.text,
            )
          : null,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  sticker,
  gif,
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final bool isSent;
  final String? mediaUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.isSent,
    this.mediaUrl,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isRead,
    bool? isSent,
    String? mediaUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isSent: isSent ?? this.isSent,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isSent': isSent,
      'mediaUrl': mediaUrl,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      isSent: json['isSent'],
      mediaUrl: json['mediaUrl'],
    );
  }
}