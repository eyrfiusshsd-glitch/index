class CommentModel {
  final String id;
  final String username;
  final String userAvatar;
  final String comment;
  int likes;
  final String timeAgo;
  bool isLiked;
  final List<CommentModel>? replies;

  CommentModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.comment,
    required this.likes,
    required this.timeAgo,
    required this.isLiked,
    this.replies,
  });

  CommentModel copyWith({
    String? id,
    String? username,
    String? userAvatar,
    String? comment,
    int? likes,
    String? timeAgo,
    bool? isLiked,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      comment: comment ?? this.comment,
      likes: likes ?? this.likes,
      timeAgo: timeAgo ?? this.timeAgo,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatar': userAvatar,
      'comment': comment,
      'likes': likes,
      'timeAgo': timeAgo,
      'isLiked': isLiked,
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      comment: json['comment'],
      likes: json['likes'],
      timeAgo: json['timeAgo'],
      isLiked: json['isLiked'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((reply) => CommentModel.fromJson(reply))
              .toList()
          : null,
    );
  }
}