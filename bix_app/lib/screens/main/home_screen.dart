import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/video_player_widget.dart';
import '../../models/video_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentVideoIndex = 0;
  
  // Mock video data
  final List<VideoModel> _videos = [
    VideoModel(
      id: '1',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      thumbnailUrl: 'https://picsum.photos/400/600?random=1',
      username: 'onepieceedit',
      userAvatar: 'https://picsum.photos/50/50?random=1',
      description: 'الأفضل في كل وقت 👑 الأفضل في كل وقت...#onepiece #fyp #viral #momentepica',
      likes: 4786,
      comments: 671,
      shares: 156,
      isLiked: false,
      isFollowing: false,
    ),
    VideoModel(
      id: '2',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
      thumbnailUrl: 'https://picsum.photos/400/600?random=2',
      username: 'ahmed_user',
      userAvatar: 'https://picsum.photos/50/50?random=2',
      description: 'فيديو رائع جداً! تابعوني للمزيد من المحتوى الممتع',
      likes: 2341,
      comments: 234,
      shares: 89,
      isLiked: true,
      isFollowing: true,
    ),
    VideoModel(
      id: '3',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
      thumbnailUrl: 'https://picsum.photos/400/600?random=3',
      username: 'creative_content',
      userAvatar: 'https://picsum.photos/50/50?random=3',
      description: 'محتوى إبداعي جديد! شاركوا آرائكم في التعليقات',
      likes: 5672,
      comments: 892,
      shares: 234,
      isLiked: false,
      isFollowing: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'لك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              child: const Text(
                'متابعة',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              child: const Text(
                'اكتشف',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.live_tv,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (index) {
          setState(() {
            _currentVideoIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            video: _videos[index],
            isPlaying: index == _currentVideoIndex,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}