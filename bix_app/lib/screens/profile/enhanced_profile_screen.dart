import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../constants/app_colors.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/user_model.dart';
import '../../models/video_model.dart';
import '../settings/enhanced_settings_screen.dart';
import '../notifications/notifications_screen.dart';
import 'edit_profile_screen.dart';

class EnhancedProfileScreen extends StatefulWidget {
  const EnhancedProfileScreen({super.key});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LanguageController _languageController = Get.find<LanguageController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  // Sample user data
  final UserModel _currentUser = UserModel(
    id: 'current_user',
    username: 'bix_user',
    displayName: 'مستخدم Bix',
    avatar: 'https://picsum.photos/200/200?random=user',
    bio: 'مرحباً بكم في ملفي الشخصي! أحب إنشاء المحتوى الإبداعي ومشاركة اللحظات المميزة معكم 🎬✨',
    followers: 12500,
    following: 890,
    videosCount: 156,
    likesCount: 45600,
    isVerified: true,
    isOnline: true,
    lastSeen: 'متصل الآن',
  );

  List<VideoModel> _userVideos = [];
  List<VideoModel> _likedVideos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserVideos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserVideos() {
    // Sample videos data
    _userVideos = List.generate(20, (index) => VideoModel(
      id: 'video_$index',
      userId: _currentUser.id,
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_${index + 1}.mp4',
      thumbnailUrl: 'https://picsum.photos/300/400?random=$index',
      description: 'فيديو رقم ${index + 1} - محتوى إبداعي ومميز',
      hashtags: ['#bix', '#creative', '#fun'],
      likesCount: (index + 1) * 100,
      commentsCount: (index + 1) * 20,
      sharesCount: (index + 1) * 5,
      viewsCount: (index + 1) * 1000,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      user: _currentUser,
    ));

    _likedVideos = List.generate(15, (index) => VideoModel(
      id: 'liked_video_$index',
      userId: 'other_user_$index',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_${index + 1}.mp4',
      thumbnailUrl: 'https://picsum.photos/300/400?random=${index + 100}',
      description: 'فيديو أعجبني رقم ${index + 1}',
      hashtags: ['#trending', '#viral'],
      likesCount: (index + 1) * 150,
      commentsCount: (index + 1) * 30,
      sharesCount: (index + 1) * 8,
      viewsCount: (index + 1) * 1500,
      createdAt: DateTime.now().subtract(Duration(days: index + 10)),
      user: UserModel(
        id: 'other_user_$index',
        username: 'user_$index',
        displayName: 'مستخدم $index',
        avatar: 'https://picsum.photos/100/100?random=${index + 200}',
        followers: 1000,
        following: 500,
        videosCount: 50,
        isVerified: index % 3 == 0,
        isOnline: false,
        lastSeen: 'منذ ${index + 1} ساعة',
      ),
    ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 400,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const NotificationsScreen());
                  },
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => const EnhancedSettingsScreen());
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.grid_on),
                    text: _languageController.isArabic ? 'الفيديوهات' : 'Videos',
                  ),
                  Tab(
                    icon: const Icon(Icons.favorite_border),
                    text: _languageController.isArabic ? 'الإعجابات' : 'Likes',
                  ),
                  Tab(
                    icon: const Icon(Icons.bookmark_border),
                    text: _languageController.isArabic ? 'المحفوظات' : 'Saved',
                  ),
                ],
              ),
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVideosGrid(_userVideos),
                  _buildVideosGrid(_likedVideos),
                  _buildVideosGrid([]), // Empty saved videos for now
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 60), // Space for app bar
          
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _currentUser.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 60),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 60),
                    ),
                  ),
                ),
              ),
              if (_currentUser.isOnline)
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Username and Verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentUser.displayName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
              if (_currentUser.isVerified) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.verified,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ],
          ),
          
          Text(
            '@${_currentUser.username}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bio
          if (_currentUser.bio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _currentUser.bio,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.4,
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                _formatNumber(_currentUser.videosCount),
                _languageController.isArabic ? 'فيديو' : 'Videos',
              ),
              _buildStatItem(
                _formatNumber(_currentUser.followers),
                _languageController.isArabic ? 'متابع' : 'Followers',
              ),
              _buildStatItem(
                _formatNumber(_currentUser.following),
                _languageController.isArabic ? 'متابَع' : 'Following',
              ),
              _buildStatItem(
                _formatNumber(_currentUser.likesCount),
                _languageController.isArabic ? 'إعجاب' : 'Likes',
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const EditProfileScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _languageController.isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    // Share profile
                  },
                  icon: const Icon(Icons.share_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headlineMedium?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVideosGrid(List<VideoModel> videos) {
    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _languageController.isArabic ? 'لا توجد فيديوهات' : 'No videos yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(VideoModel video) {
    final random = video.id.hashCode % 3;
    return GestureDetector(
      onTap: () {
        // Navigate to video player
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Video Thumbnail
              CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: (random == 0) ? 200 : 150, // Varied heights
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.play_circle_filled, size: 40),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.play_circle_filled, size: 40),
                ),
              ),
              
              // Play Button Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              
              // Video Stats
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatNumber(video.likesCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatNumber(video.viewsCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}