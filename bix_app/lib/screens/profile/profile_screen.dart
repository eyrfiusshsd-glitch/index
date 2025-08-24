import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../constants/app_colors.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock user data
  final String _username = 'bix_user';
  final String _displayName = 'مستخدم Bix';
  final String _bio = 'مرحباً بكم في ملفي الشخصي! 🎬\nأحب إنشاء المحتوى الإبداعي';
  final String _avatar = 'https://picsum.photos/150/150?random=profile';
  final int _followers = 1234;
  final int _following = 567;
  final int _likes = 89012;
  
  // Mock videos
  final List<String> _userVideos = [
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
    'https://picsum.photos/200/300?random=6',
    'https://picsum.photos/200/300?random=7',
    'https://picsum.photos/200/300?random=8',
    'https://picsum.photos/200/300?random=9',
  ];
  
  final List<String> _likedVideos = [
    'https://picsum.photos/200/300?random=10',
    'https://picsum.photos/200/300?random=11',
    'https://picsum.photos/200/300?random=12',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text(
              _username,
              style: const TextStyle(
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
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar and stats
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _avatar,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey,
                              child: const Icon(Icons.person, color: Colors.white, size: 40),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey,
                              child: const Icon(Icons.person, color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 30),
                      
                      // Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(_following.toString(), 'متابَع'),
                            _buildStatColumn(_followers.toString(), 'متابِع'),
                            _buildStatColumn(_formatCount(_likes), 'إعجاب'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Display name
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Bio
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _bio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfileScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'تعديل الملف الشخصي',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Container(
                        width: 35,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(
                            Icons.person_add_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tab bar
            Container(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.grid_on, size: 24),
                  ),
                  Tab(
                    icon: Icon(Icons.favorite_border, size: 24),
                  ),
                ],
              ),
            ),
            
            // Tab content
            Container(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // User videos
                  _buildVideoGrid(_userVideos),
                  
                  // Liked videos
                  _buildVideoGrid(_likedVideos),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoGrid(List<String> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              color: Colors.grey,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد فيديوهات',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(2),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Open video player
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: videos[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150 + (index % 3) * 50.0,
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150 + (index % 3) * 50.0,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Play icon
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  
                  // View count
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatCount((index + 1) * 1234),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}