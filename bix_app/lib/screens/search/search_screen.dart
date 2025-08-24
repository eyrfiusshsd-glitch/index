import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'أساسي';
  
  final List<String> _categories = ['أساسي', 'عام', 'الطلبات'];
  
  final List<UserModel> _users = [
    UserModel(
      id: '1',
      username: 'AmjR',
      displayName: 'AmjR',
      avatar: 'https://picsum.photos/100/100?random=1',
      isVerified: false,
      followers: 0,
      isOnline: true,
      lastSeen: 'نشط منذ 2 س',
    ),
    UserModel(
      id: '2',
      username: 'مخفف',
      displayName: 'مخفف',
      avatar: 'https://picsum.photos/100/100?random=2',
      isVerified: false,
      followers: 0,
      isOnline: false,
      lastSeen: 'نشط الآن',
    ),
    UserModel(
      id: '3',
      username: 'Afra',
      displayName: 'Afra',
      avatar: 'https://picsum.photos/100/100?random=3',
      isVerified: true,
      followers: 0,
      isOnline: false,
      lastSeen: 'تم إرسال الجمعة',
    ),
    UserModel(
      id: '4',
      username: 'ajirlyiq',
      displayName: 'ajirlyiq',
      avatar: 'https://picsum.photos/100/100?random=4',
      isVerified: true,
      followers: 0,
      isOnline: false,
      lastSeen: 'كان نشطًا منذ ساعة',
    ),
    UserModel(
      id: '5',
      username: 'Ahmad Aburob',
      displayName: 'أحمد أبو الرب Ahmad Aburob',
      avatar: 'https://picsum.photos/100/100?random=5',
      isVerified: true,
      followers: 0,
      isOnline: false,
      lastSeen: 'تم إرسال الأربعاء',
    ),
    UserModel(
      id: '6',
      username: 'super.sttore',
      displayName: 'super.sttore',
      avatar: 'https://picsum.photos/100/100?random=6',
      isVerified: true,
      followers: 0,
      isOnline: false,
      lastSeen: 'تم التفاعل باستخدام 😍 مع رسائلك في',
    ),
    UserModel(
      id: '7',
      username: 'christo',
      displayName: 'christo',
      avatar: 'https://picsum.photos/100/100?random=7',
      isVerified: false,
      followers: 0,
      isOnline: false,
      lastSeen: 'نشط اليوم',
    ),
  ];

  final List<String> _trendingHashtags = [
    '#onepiece',
    '#fyp',
    '#viral',
    '#momentepica',
    '#anime',
    '#luffy',
    '#zoro',
    '#sanji',
    '#nami',
    '#chopper',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  Container(
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
                  
                  const SizedBox(height: 16),
                  
                  // Story-like avatars
                  Row(
                    children: [
                      _buildStoryAvatar(
                        'عيدي كهيدك ما الدنيا تغيرة وان تغير مك',
                        'مشاركة ملاحظة',
                        'https://picsum.photos/60/60?random=10',
                      ),
                      const SizedBox(width: 12),
                      _buildStoryAvatar(
                        'ahmed',
                        'ملاحظتك',
                        'https://picsum.photos/60/60?random=11',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Categories
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return _buildUserItem(_users[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryAvatar(String title, String subtitle, String imageUrl) {
    return Column(
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
              imageUrl: imageUrl,
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
        SizedBox(
          width: 80,
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildUserItem(UserModel user) {
    return Container(
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
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (user.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  user.lastSeen,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // User avatar
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: user.isOnline 
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
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
              if (user.isOnline)
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}