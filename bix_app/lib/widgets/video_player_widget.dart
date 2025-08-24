import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/video_model.dart';
import '../widgets/comments_bottom_sheet.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;
  final bool isPlaying;

  const VideoPlayerWidget({
    super.key,
    required this.video,
    required this.isPlaying,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLiked = false;
  bool _isFollowing = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _isLiked = widget.video.isLiked;
    _isFollowing = widget.video.isFollowing;
    _likes = widget.video.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Background (using image as placeholder)
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            imageUrl: widget.video.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black26,
                Colors.black54,
              ],
            ),
          ),
        ),

        // Right side actions
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              // User Avatar with Follow Button
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.video.userAvatar,
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
                  if (!_isFollowing)
                    Positioned(
                      bottom: -8,
                      child: GestureDetector(
                        onTap: _toggleFollow,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Like Button
              _buildActionButton(
                icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? AppColors.primary : Colors.white,
                count: _formatCount(_likes),
                onTap: _toggleLike,
              ),

              const SizedBox(height: 24),

              // Comment Button
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                color: Colors.white,
                count: _formatCount(widget.video.comments),
                onTap: _showComments,
              ),

              const SizedBox(height: 24),

              // Share Button
              _buildActionButton(
                icon: Icons.share,
                color: Colors.white,
                count: _formatCount(widget.video.shares),
                onTap: _shareVideo,
              ),

              const SizedBox(height: 24),

              // More Options
              _buildActionButton(
                icon: Icons.more_vert,
                color: Colors.white,
                count: '',
                onTap: _showMoreOptions,
              ),
            ],
          ),
        ),

        // Bottom content
        Positioned(
          left: 12,
          right: 80,
          bottom: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              Text(
                '@${widget.video.username}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                widget.video.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Music/Sound info
              Row(
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'الصوت الأصلي - ${widget.video.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Play/Pause overlay
        if (!widget.isPlaying)
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          if (count.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });

    if (_isLiked) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(videoId: widget.video.id),
    );
  }

  void _shareVideo() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الرابط'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showMoreOptions() {
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
              leading: const Icon(Icons.report, color: Colors.white),
              title: const Text('إبلاغ', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.white),
              title: const Text('حظر المستخدم', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.white),
              title: const Text('حفظ الفيديو', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
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
    _animationController.dispose();
    super.dispose();
  }
}