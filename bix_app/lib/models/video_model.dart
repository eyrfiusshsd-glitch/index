class VideoModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String username;
  final String userAvatar;
  final String description;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isFollowing;
  final List<String>? hashtags;
  final DateTime? createdAt;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.username,
    required this.userAvatar,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isFollowing,
    this.hashtags,
    this.createdAt,
  });

  VideoModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? username,
    String? userAvatar,
    String? description,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isFollowing,
    List<String>? hashtags,
    DateTime? createdAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      hashtags: hashtags ?? this.hashtags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'username': username,
      'userAvatar': userAvatar,
      'description': description,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isFollowing': isFollowing,
      'hashtags': hashtags,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      description: json['description'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
      isLiked: json['isLiked'],
      isFollowing: json['isFollowing'],
      hashtags: json['hashtags'] != null ? List<String>.from(json['hashtags']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}