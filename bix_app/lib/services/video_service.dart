import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/video_model.dart';
import '../models/comment_model.dart';

class VideoService {
  static final VideoService _instance = VideoService._internal();
  factory VideoService() => _instance;
  VideoService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  final String _videosCollection = 'videos';
  final String _commentsCollection = 'comments';
  final String _likesCollection = 'likes';

  // Get videos for home feed
  Future<List<VideoModel>> getHomeVideos({int limit = 10}) async {
    try {
      // Mock data for demonstration
      return _getMockVideos();
    } catch (e) {
      throw 'فشل في تحميل الفيديوهات: $e';
    }
  }

  // Get user videos
  Future<List<VideoModel>> getUserVideos(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_videosCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => VideoModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      // Return mock data if Firestore is not available
      return _getMockUserVideos();
    }
  }

  // Upload video
  Future<String> uploadVideo({
    required File videoFile,
    required String title,
    required String description,
    required String userId,
    List<String>? hashtags,
  }) async {
    try {
      // Upload video to Firebase Storage
      final videoRef = _storage
          .ref()
          .child('videos')
          .child('${DateTime.now().millisecondsSinceEpoch}.mp4');
      
      final uploadTask = await videoRef.putFile(videoFile);
      final videoUrl = await uploadTask.ref.getDownloadURL();

      // Create video document
      final videoData = {
        'videoUrl': videoUrl,
        'title': title,
        'description': description,
        'userId': userId,
        'hashtags': hashtags ?? [],
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_videosCollection).add(videoData);
      return docRef.id;
    } catch (e) {
      throw 'فشل في رفع الفيديو: $e';
    }
  }

  // Like/Unlike video
  Future<void> toggleLike(String videoId, String userId) async {
    try {
      final likeDoc = _firestore
          .collection(_likesCollection)
          .doc('${videoId}_$userId');

      final likeSnapshot = await likeDoc.get();
      
      if (likeSnapshot.exists) {
        // Unlike
        await likeDoc.delete();
        await _updateVideoLikeCount(videoId, -1);
      } else {
        // Like
        await likeDoc.set({
          'videoId': videoId,
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _updateVideoLikeCount(videoId, 1);
      }
    } catch (e) {
      throw 'فشل في تحديث الإعجاب: $e';
    }
  }

  // Add comment
  Future<String> addComment({
    required String videoId,
    required String userId,
    required String comment,
    String? parentCommentId,
  }) async {
    try {
      final commentData = {
        'videoId': videoId,
        'userId': userId,
        'comment': comment,
        'parentCommentId': parentCommentId,
        'likes': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_commentsCollection).add(commentData);
      
      // Update video comment count
      await _updateVideoCommentCount(videoId, 1);
      
      return docRef.id;
    } catch (e) {
      throw 'فشل في إضافة التعليق: $e';
    }
  }

  // Get video comments
  Future<List<CommentModel>> getVideoComments(String videoId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_commentsCollection)
          .where('videoId', isEqualTo: videoId)
          .where('parentCommentId', isNull: true)
          .orderBy('createdAt', descending: true)
          .get();

      List<CommentModel> comments = [];
      
      for (var doc in querySnapshot.docs) {
        final commentData = doc.data();
        final comment = CommentModel.fromJson({...commentData, 'id': doc.id});
        
        // Get replies
        final repliesSnapshot = await _firestore
            .collection(_commentsCollection)
            .where('parentCommentId', isEqualTo: doc.id)
            .orderBy('createdAt')
            .get();
        
        final replies = repliesSnapshot.docs
            .map((replyDoc) => CommentModel.fromJson({...replyDoc.data(), 'id': replyDoc.id}))
            .toList();
        
        comments.add(comment.copyWith(replies: replies));
      }
      
      return comments;
    } catch (e) {
      // Return mock comments if Firestore is not available
      return _getMockComments();
    }
  }

  // Search videos
  Future<List<VideoModel>> searchVideos(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_videosCollection)
          .where('description', isGreaterThanOrEqualTo: query)
          .where('description', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => VideoModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      // Return mock search results
      return _getMockSearchResults(query);
    }
  }

  // Get trending videos
  Future<List<VideoModel>> getTrendingVideos() async {
    try {
      final querySnapshot = await _firestore
          .collection(_videosCollection)
          .orderBy('likes', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => VideoModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return _getMockTrendingVideos();
    }
  }

  // Private helper methods
  Future<void> _updateVideoLikeCount(String videoId, int increment) async {
    try {
      await _firestore.collection(_videosCollection).doc(videoId).update({
        'likes': FieldValue.increment(increment),
      });
    } catch (e) {
      // Handle error silently for mock implementation
    }
  }

  Future<void> _updateVideoCommentCount(String videoId, int increment) async {
    try {
      await _firestore.collection(_videosCollection).doc(videoId).update({
        'comments': FieldValue.increment(increment),
      });
    } catch (e) {
      // Handle error silently for mock implementation
    }
  }

  // Mock data methods
  List<VideoModel> _getMockVideos() {
    return [
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
        hashtags: ['onepiece', 'fyp', 'viral', 'momentepica'],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
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
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
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
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
  }

  List<VideoModel> _getMockUserVideos() {
    return [
      VideoModel(
        id: 'user1',
        videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        thumbnailUrl: 'https://picsum.photos/200/300?random=10',
        username: 'current_user',
        userAvatar: 'https://picsum.photos/50/50?random=100',
        description: 'فيديو من إنتاجي الخاص',
        likes: 123,
        comments: 45,
        shares: 12,
        isLiked: false,
        isFollowing: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<CommentModel> _getMockComments() {
    return [
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
    ];
  }

  List<VideoModel> _getMockSearchResults(String query) {
    return _getMockVideos()
        .where((video) => video.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<VideoModel> _getMockTrendingVideos() {
    return _getMockVideos()..sort((a, b) => b.likes.compareTo(a.likes));
  }
}