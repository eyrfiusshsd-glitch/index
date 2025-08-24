import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/comment_model.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String videoId;

  const CommentsBottomSheet({
    super.key,
    required this.videoId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<CommentModel> _comments = [
    CommentModel(
      id: '1',
      username: 'محمد أحمد',
      userAvatar: 'https://picsum.photos/50/50?random=10',
      comment: 'من يفكر نفسي أن لوفي بدون الجير الخامس كان له هيبة أوحدها 😍😍',
      likes: 135,
      timeAgo: '27-7',
      isLiked: false,
      replies: [
        CommentModel(
          id: '1-1',
          username: 'سارة علي',
          userAvatar: 'https://picsum.photos/50/50?random=11',
          comment: 'صحيح، كان أقوى بكثير',
          likes: 12,
          timeAgo: '27-7',
          isLiked: true,
        ),
      ],
    ),
    CommentModel(
      id: '2',
      username: 'أحمد محمد',
      userAvatar: 'https://picsum.photos/50/50?random=12',
      comment: 'أعظم تسجيل دخول في ون بيس',
      likes: 66,
      timeAgo: '27-7',
      isLiked: false,
    ),
    CommentModel(
      id: '3',
      username: 'husen06',
      userAvatar: 'https://picsum.photos/50/50?random=13',
      comment: 'رائع جداً! 🔥',
      likes: 23,
      timeAgo: '26-7',
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عرض ${_comments.length} ردود',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  '688 تعليقًا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.grey, height: 1),

          // Comments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _buildCommentItem(_comments[index]);
              },
            ),
          ),

          // Comment input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Gift icon
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Mention icon
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.alternate_email,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Emoji icon
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Image icon
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Text input
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'إضافة تعليق...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                // Send button
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: comment.userAvatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Comment content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and time
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          comment.timeAgo,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Comment text
                    Text(
                      comment.comment,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Actions
                    Row(
                      children: [
                        Text(
                          'رد',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Like button
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        comment.isLiked = !comment.isLiked;
                        comment.likes += comment.isLiked ? 1 : -1;
                      });
                    },
                    child: Icon(
                      comment.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: comment.isLiked ? AppColors.primary : Colors.grey,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.likes.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Replies
          if (comment.replies != null && comment.replies!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12, right: 44),
              child: Column(
                children: comment.replies!
                    .map((reply) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: _buildCommentItem(reply),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}