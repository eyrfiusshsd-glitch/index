import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../controllers/language_controller.dart';
import '../models/video_model.dart';
import '../widgets/comments_bottom_sheet.dart';

class EnhancedVideoPlayerWidget extends StatefulWidget {
  final VideoModel video;
  final bool isPlaying;

  const EnhancedVideoPlayerWidget({
    super.key,
    required this.video,
    required this.isPlaying,
  });

  @override
  State<EnhancedVideoPlayerWidget> createState() => _EnhancedVideoPlayerWidgetState();
}

class _EnhancedVideoPlayerWidgetState extends State<EnhancedVideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final LanguageController _languageController = Get.find<LanguageController>();
  
  bool _isLiked = false;
  bool _isFollowing = false;
  bool _isSaved = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likesCount = widget.video.likesCount;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
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

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        videoId: widget.video.id,
      ),
    );
  }

  void _shareVideo() {
    // Implement share functionality
    Get.snackbar(
      _languageController.isArabic ? 'مشاركة' : 'Share',
      _languageController.isArabic ? 'تم نسخ الرابط' : 'Link copied',
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Background
        Container(
          color: Colors.black,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.video.thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
        
        // Play/Pause Overlay
        if (widget.isPlaying)
          GestureDetector(
            onTap: () {
              // Toggle play/pause
            },
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white70,
                  size: 80,
                ),
              ),
            ),
          ),
        
        // Right Side Actions
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              // User Avatar + Follow Button
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to user profile
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.video.user.avatar,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person),
                          ),
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
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
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
                label: _formatNumber(_likesCount),
                onTap: _toggleLike,
                animation: _isLiked ? _animationController : null,
              ),
              
              const SizedBox(height: 24),
              
              // Comment Button
              _buildActionButton(
                icon: Icons.comment,
                color: Colors.white,
                label: _formatNumber(widget.video.commentsCount),
                onTap: _showComments,
              ),
              
              const SizedBox(height: 24),
              
              // Share Button
              _buildActionButton(
                icon: Icons.share,
                color: Colors.white,
                label: _formatNumber(widget.video.sharesCount),
                onTap: _shareVideo,
              ),
              
              const SizedBox(height: 24),
              
              // Save Button
              _buildActionButton(
                icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? Colors.yellow : Colors.white,
                label: '',
                onTap: _toggleSave,
              ),
              
              const SizedBox(height: 24),
              
              // More Options
              _buildActionButton(
                icon: Icons.more_vert,
                color: Colors.white,
                label: '',
                onTap: () {
                  _showMoreOptions();
                },
              ),
            ],
          ),
        ),
        
        // Bottom Info
        Positioned(
          left: 12,
          right: 80,
          bottom: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              Row(
                children: [
                  Text(
                    '@${widget.video.user.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.video.user.isVerified) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ],
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
              
              const SizedBox(height: 8),
              
              // Hashtags
              if (widget.video.hashtags.isNotEmpty)
                Wrap(
                  children: widget.video.hashtags.map((hashtag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      child: Text(
                        hashtag,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 8),
              
              // Music/Sound Info
              Row(
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _languageController.isArabic 
                          ? 'الصوت الأصلي - ${widget.video.user.displayName}'
                          : 'Original sound - ${widget.video.user.displayName}',
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
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    AnimationController? animation,
  }) {
    Widget iconWidget = Icon(
      icon,
      color: color,
      size: 32,
    );

    if (animation != null) {
      iconWidget = ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.3).animate(
          CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        ),
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: Text(_languageController.isArabic ? 'إبلاغ' : 'Report'),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(_languageController.isArabic ? 'حظر المستخدم' : 'Block user'),
              onTap: () {
                Navigator.pop(context);
                // Handle block
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(_languageController.isArabic ? 'نسخ الرابط' : 'Copy link'),
              onTap: () {
                Navigator.pop(context);
                _shareVideo();
              },
            ),
          ],
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