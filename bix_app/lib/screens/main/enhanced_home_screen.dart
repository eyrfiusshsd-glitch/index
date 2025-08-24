import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/language_controller.dart';
import '../../models/video_model.dart';
import '../../models/user_model.dart';
import '../../widgets/enhanced_video_player_widget.dart';
import '../notifications/notifications_screen.dart';
import '../search/new_search_screen.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  final LanguageController _languageController = Get.find<LanguageController>();
  
  List<VideoModel> _forYouVideos = [];
  List<VideoModel> _followingVideos = [];
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadVideos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _loadVideos() {
    // Sample videos for "For You" tab
    _forYouVideos = List.generate(10, (index) {
      return VideoModel(
        id: 'video_$index',
        userId: 'user_$index',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_${index + 1}.mp4',
        thumbnailUrl: 'https://picsum.photos/400/600?random=$index',
        description: 'فيديو مميز رقم ${index + 1} - محتوى إبداعي ومسلي للجميع! #bix #viral #trending',
        hashtags: ['#bix', '#viral', '#trending', '#fun'],
        likesCount: (index + 1) * 1250,
        commentsCount: (index + 1) * 89,
        sharesCount: (index + 1) * 23,
        viewsCount: (index + 1) * 15600,
        createdAt: DateTime.now().subtract(Duration(hours: index + 1)),
        user: UserModel(
          id: 'user_$index',
          username: 'creator_$index',
          displayName: 'منشئ المحتوى ${index + 1}',
          avatar: 'https://picsum.photos/100/100?random=${index + 50}',
          followers: (index + 1) * 5000,
          following: (index + 1) * 200,
          videosCount: (index + 1) * 25,
          isVerified: index % 3 == 0,
          isOnline: index % 2 == 0,
          lastSeen: index % 2 == 0 ? 'متصل الآن' : 'منذ ${index + 1} ساعة',
        ),
      );
    });

    // Sample videos for "Following" tab
    _followingVideos = List.generate(8, (index) {
      return VideoModel(
        id: 'following_video_$index',
        userId: 'following_user_$index',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_${index + 1}.mp4',
        thumbnailUrl: 'https://picsum.photos/400/600?random=${index + 100}',
        description: 'فيديو من المتابعين رقم ${index + 1} - محتوى حصري من الأصدقاء',
        hashtags: ['#friends', '#following', '#exclusive'],
        likesCount: (index + 1) * 890,
        commentsCount: (index + 1) * 45,
        sharesCount: (index + 1) * 12,
        viewsCount: (index + 1) * 8900,
        createdAt: DateTime.now().subtract(Duration(hours: index + 2)),
        user: UserModel(
          id: 'following_user_$index',
          username: 'friend_$index',
          displayName: 'صديق ${index + 1}',
          avatar: 'https://picsum.photos/100/100?random=${index + 150}',
          followers: (index + 1) * 2000,
          following: (index + 1) * 800,
          videosCount: (index + 1) * 15,
          isVerified: index % 4 == 0,
          isOnline: true,
          lastSeen: 'متصل الآن',
        ),
      );
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Feed
          TabBarView(
            controller: _tabController,
            children: [
              _buildVideoFeed(_forYouVideos),
              _buildVideoFeed(_followingVideos),
            ],
          ),
          
          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Search Button
          IconButton(
            onPressed: () {
              Get.to(() => const NewSearchScreen());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          const Spacer(),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(text: _languageController.isArabic ? 'لك' : 'For You'),
                Tab(text: _languageController.isArabic ? 'المتابعون' : 'Following'),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Notifications Button
          IconButton(
            onPressed: () {
              Get.to(() => const NotificationsScreen());
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
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

  Widget _buildVideoFeed(List<VideoModel> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() {
          _currentVideoIndex = index;
        });
      },
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return EnhancedVideoPlayerWidget(
          video: video,
          isPlaying: index == _currentVideoIndex,
        );
      },
    );
  }
}