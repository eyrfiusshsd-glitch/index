import 'user_model.dart';

class VideoModel {
  final String id;
  final String userId;
  final String videoUrl;
  final String thumbnailUrl;
  final String description;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isFollowing;
  final List<String> hashtags;
  final DateTime createdAt;
  final UserModel user;

  VideoModel({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.description,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.viewsCount,
    this.isLiked = false,
    this.isFollowing = false,
    required this.hashtags,
    required this.createdAt,
    required this.user,
  });

  VideoModel copyWith({
    String? id,
    String? userId,
    String? videoUrl,
    String? thumbnailUrl,
    String? description,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isLiked,
    bool? isFollowing,
    List<String>? hashtags,
    DateTime? createdAt,
    UserModel? user,
  }) {
    return VideoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      hashtags: hashtags ?? this.hashtags,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'isLiked': isLiked,
      'isFollowing': isFollowing,
      'hashtags': hashtags,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      userId: json['userId'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      sharesCount: json['sharesCount'],
      viewsCount: json['viewsCount'],
      isLiked: json['isLiked'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']),
    );
  }
}