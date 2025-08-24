import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/language_controller.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LanguageController _languageController = Get.find<LanguageController>();
  
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> _followNotifications = [];
  List<NotificationModel> _likeNotifications = [];
  List<NotificationModel> _commentNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    // Sample notifications data
    _allNotifications = [
      NotificationModel(
        id: '1',
        type: NotificationType.like,
        title: 'أعجب أحمد بفيديوك',
        message: 'أعجب أحمد بالفيديو الذي نشرته',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        userAvatar: 'https://picsum.photos/50/50?random=1',
        userName: 'أحمد محمد',
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.follow,
        title: 'بدأت سارة بمتابعتك',
        message: 'سارة أحمد بدأت بمتابعة حسابك',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        userAvatar: 'https://picsum.photos/50/50?random=2',
        userName: 'سارة أحمد',
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.comment,
        title: 'علق محمد على فيديوك',
        message: 'فيديو رائع! أحببت المحتوى',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        userAvatar: 'https://picsum.photos/50/50?random=3',
        userName: 'محمد علي',
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.mention,
        title: 'ذكرك فادي في فيديو',
        message: 'ذكرك فادي في فيديو جديد',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        userAvatar: 'https://picsum.photos/50/50?random=4',
        userName: 'فادي خالد',
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.system,
        title: 'تحديث جديد متوفر',
        message: 'يتوفر تحديث جديد للتطبيق مع ميزات محسنة',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        userAvatar: '',
        userName: 'Bix',
      ),
    ];

    // Filter notifications by type
    _followNotifications = _allNotifications
        .where((n) => n.type == NotificationType.follow)
        .toList();
    _likeNotifications = _allNotifications
        .where((n) => n.type == NotificationType.like)
        .toList();
    _commentNotifications = _allNotifications
        .where((n) => n.type == NotificationType.comment)
        .toList();

    setState(() {});
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification = _allNotifications
          .firstWhere((n) => n.id == notificationId);
      notification.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageController.isArabic ? 'الإشعارات' : 'Notifications',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              _languageController.isArabic ? 'تحديد الكل كمقروء' : 'Mark all read',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: _languageController.isArabic ? 'الكل' : 'All'),
            Tab(text: _languageController.isArabic ? 'المتابعة' : 'Follows'),
            Tab(text: _languageController.isArabic ? 'الإعجابات' : 'Likes'),
            Tab(text: _languageController.isArabic ? 'التعليقات' : 'Comments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(_allNotifications),
          _buildNotificationsList(_followNotifications),
          _buildNotificationsList(_likeNotifications),
          _buildNotificationsList(_commentNotifications),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _languageController.isArabic ? 'لا توجد إشعارات' : 'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _languageController.isArabic 
                  ? 'ستظهر الإشعارات هنا عند وصولها'
                  : 'Notifications will appear here when they arrive',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: notification.isRead 
            ? Colors.transparent 
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => _markAsRead(notification.id),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: notification.userAvatar.isNotEmpty
                  ? NetworkImage(notification.userAvatar)
                  : null,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: notification.userAvatar.isEmpty
                  ? Icon(
                      _getNotificationIcon(notification.type),
                      color: AppColors.primary,
                      size: 20,
                    )
                  : null,
            ),
            if (!notification.isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.message.isNotEmpty)
              Text(
                notification.message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: notification.type == NotificationType.follow
            ? SizedBox(
                width: 80,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle follow back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    _languageController.isArabic ? 'متابعة' : 'Follow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.system:
        return Icons.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (_languageController.isArabic) {
      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} يوم';
      } else {
        return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
      }
    } else {
      if (difference.inMinutes < 1) {
        return 'Now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${(difference.inDays / 7).floor()}w ago';
      }
    }
  }
}