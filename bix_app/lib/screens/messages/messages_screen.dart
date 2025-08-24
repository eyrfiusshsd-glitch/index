import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../models/message_model.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<MessageModel> _conversations = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'ggy_6',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اسأل Meta AI أو ابحث',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Story-like avatars section
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Your story
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/60/60?random=100',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ملاحظتك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Friend's story
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/60/60?random=101',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ahmed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterTab('أساسي', true),
                const SizedBox(width: 20),
                _buildFilterTab('عام', false),
                const SizedBox(width: 20),
                _buildFilterTab('الطلبات', false),
                const Spacer(),
                const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(_conversations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(user: message),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            // Camera icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Message info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        message.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (message.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                      const Spacer(),
                      Text(
                        message.timestamp,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.lastMessage,
                    style: TextStyle(
                      color: message.unreadCount > 0 ? Colors.white : Colors.grey,
                      fontSize: 14,
                      fontWeight: message.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // User avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: message.isOnline 
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: message.userAvatar,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (message.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                if (message.unreadCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          message.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}