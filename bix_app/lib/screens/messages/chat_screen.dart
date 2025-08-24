import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final MessageModel user;

  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<ChatMessage> _messages = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // User avatar
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: widget.user.isOnline 
                    ? Border.all(color: Colors.green, width: 2)
                    : null,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.user.userAvatar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.user.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    widget.user.isOnline ? 'نشط الآن' : 'غير متصل',
                    style: TextStyle(
                      color: widget.user.isOnline ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Camera button
                GestureDetector(
                  onTap: _openCamera,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Text input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'اكتب رسالة...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                        
                        // Emoji button
                        IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                        
                        // Attachment button
                        IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          onPressed: _showAttachmentOptions,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Send button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.senderId == 'me';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.user.userAvatar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 15),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          color: message.isRead ? Colors.blue : Colors.white.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: 'https://picsum.photos/30/30?random=me',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 15),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        receiverId: widget.user.id,
        content: _messageController.text.trim(),
        type: MessageType.text,
        timestamp: DateTime.now(),
        isRead: false,
        isSent: true,
      );
      
      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
      
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _openCamera() {
    // Implement camera functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فتح الكاميرا...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('معرض الصور', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Implement photo gallery
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.white),
              title: const Text('فيديو', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Implement video
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.white),
              title: const Text('ملف', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Implement file
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white),
              title: const Text('الموقع', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Implement location
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
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
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}