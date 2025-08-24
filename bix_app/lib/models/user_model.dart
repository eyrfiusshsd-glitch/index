class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String avatar;
  final bool isVerified;
  final int followers;
  final int following;
  final int likes;
  final String? bio;
  final bool isOnline;
  final String lastSeen;
  final List<String>? videos;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.isVerified,
    required this.followers,
    this.following = 0,
    this.likes = 0,
    this.bio,
    required this.isOnline,
    required this.lastSeen,
    this.videos,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatar,
    bool? isVerified,
    int? followers,
    int? following,
    int? likes,
    String? bio,
    bool? isOnline,
    String? lastSeen,
    List<String>? videos,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      isVerified: isVerified ?? this.isVerified,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likes: likes ?? this.likes,
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      videos: videos ?? this.videos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatar': avatar,
      'isVerified': isVerified,
      'followers': followers,
      'following': following,
      'likes': likes,
      'bio': bio,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'videos': videos,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      avatar: json['avatar'],
      isVerified: json['isVerified'],
      followers: json['followers'],
      following: json['following'] ?? 0,
      likes: json['likes'] ?? 0,
      bio: json['bio'],
      isOnline: json['isOnline'],
      lastSeen: json['lastSeen'],
      videos: json['videos'] != null ? List<String>.from(json['videos']) : null,
    );
  }
}