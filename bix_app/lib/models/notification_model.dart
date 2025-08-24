enum NotificationType {
  like,
  comment,
  follow,
  mention,
  system,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String userAvatar;
  final String userName;
  final String? videoId;
  final String? videoThumbnail;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.userAvatar,
    required this.userName,
    this.videoId,
    this.videoThumbnail,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.system,
      ),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
      userAvatar: json['userAvatar'] ?? '',
      userName: json['userName'] ?? '',
      videoId: json['videoId'],
      videoThumbnail: json['videoThumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'userAvatar': userAvatar,
      'userName': userName,
      'videoId': videoId,
      'videoThumbnail': videoThumbnail,
    };
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? userAvatar,
    String? userName,
    String? videoId,
    String? videoThumbnail,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userAvatar: userAvatar ?? this.userAvatar,
      userName: userName ?? this.userName,
      videoId: videoId ?? this.videoId,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
    );
  }
}