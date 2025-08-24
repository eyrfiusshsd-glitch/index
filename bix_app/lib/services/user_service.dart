import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  final String _usersCollection = 'users';
  final String _followersCollection = 'followers';
  final String _followingCollection = 'following';

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      
      if (doc.exists) {
        return UserModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      // Return mock user if Firestore is not available
      return _getMockUser(userId);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? username,
    String? displayName,
    String? bio,
    String? avatar,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (username != null) updateData['username'] = username;
      if (displayName != null) updateData['displayName'] = displayName;
      if (bio != null) updateData['bio'] = bio;
      if (avatar != null) updateData['avatar'] = avatar;
      
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_usersCollection).doc(userId).update(updateData);
    } catch (e) {
      throw 'فشل في تحديث الملف الشخصي: $e';
    }
  }

  // Upload profile picture
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$userId.jpg');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      // Update user profile with new avatar URL
      await updateUserProfile(userId: userId, avatar: downloadUrl);
      
      return downloadUrl;
    } catch (e) {
      throw 'فشل في رفع صورة الملف الشخصي: $e';
    }
  }

  // Follow/Unfollow user
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      final followDoc = _firestore
          .collection(_followingCollection)
          .doc('${currentUserId}_$targetUserId');

      final followSnapshot = await followDoc.get();
      
      if (followSnapshot.exists) {
        // Unfollow
        await followDoc.delete();
        await _updateFollowCount(currentUserId, 'following', -1);
        await _updateFollowCount(targetUserId, 'followers', -1);
      } else {
        // Follow
        await followDoc.set({
          'followerId': currentUserId,
          'followingId': targetUserId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _updateFollowCount(currentUserId, 'following', 1);
        await _updateFollowCount(targetUserId, 'followers', 1);
      }
    } catch (e) {
      throw 'فشل في تحديث المتابعة: $e';
    }
  }

  // Get followers
  Future<List<UserModel>> getFollowers(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_followersCollection)
          .where('followingId', isEqualTo: userId)
          .get();

      List<UserModel> followers = [];
      
      for (var doc in querySnapshot.docs) {
        final followerId = doc.data()['followerId'];
        final user = await getUserProfile(followerId);
        if (user != null) {
          followers.add(user);
        }
      }
      
      return followers;
    } catch (e) {
      return _getMockFollowers();
    }
  }

  // Get following
  Future<List<UserModel>> getFollowing(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_followingCollection)
          .where('followerId', isEqualTo: userId)
          .get();

      List<UserModel> following = [];
      
      for (var doc in querySnapshot.docs) {
        final followingId = doc.data()['followingId'];
        final user = await getUserProfile(followingId);
        if (user != null) {
          following.add(user);
        }
      }
      
      return following;
    } catch (e) {
      return _getMockFollowing();
    }
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('username', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return _getMockSearchResults(query);
    }
  }

  // Get suggested users
  Future<List<UserModel>> getSuggestedUsers(String currentUserId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('id', isNotEqualTo: currentUserId)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return _getMockSuggestedUsers();
    }
  }

  // Block user
  Future<void> blockUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('blocked_users').add({
        'blockerId': currentUserId,
        'blockedId': targetUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'فشل في حظر المستخدم: $e';
    }
  }

  // Report user
  Future<void> reportUser({
    required String reporterId,
    required String reportedUserId,
    required String reason,
    String? description,
  }) async {
    try {
      await _firestore.collection('user_reports').add({
        'reporterId': reporterId,
        'reportedUserId': reportedUserId,
        'reason': reason,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      throw 'فشل في الإبلاغ عن المستخدم: $e';
    }
  }

  // Private helper methods
  Future<void> _updateFollowCount(String userId, String field, int increment) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        field: FieldValue.increment(increment),
      });
    } catch (e) {
      // Handle error silently for mock implementation
    }
  }

  // Mock data methods
  UserModel _getMockUser(String userId) {
    return UserModel(
      id: userId,
      username: 'bix_user',
      displayName: 'مستخدم Bix',
      avatar: 'https://picsum.photos/150/150?random=profile',
      isVerified: false,
      followers: 1234,
      following: 567,
      likes: 89012,
      bio: 'مرحباً بكم في ملفي الشخصي! 🎬\nأحب إنشاء المحتوى الإبداعي',
      isOnline: true,
      lastSeen: 'نشط الآن',
    );
  }

  List<UserModel> _getMockFollowers() {
    return [
      UserModel(
        id: '1',
        username: 'follower1',
        displayName: 'متابع 1',
        avatar: 'https://picsum.photos/50/50?random=1',
        isVerified: false,
        followers: 100,
        isOnline: true,
        lastSeen: 'نشط الآن',
      ),
      UserModel(
        id: '2',
        username: 'follower2',
        displayName: 'متابع 2',
        avatar: 'https://picsum.photos/50/50?random=2',
        isVerified: true,
        followers: 500,
        isOnline: false,
        lastSeen: 'منذ ساعة',
      ),
    ];
  }

  List<UserModel> _getMockFollowing() {
    return [
      UserModel(
        id: '3',
        username: 'following1',
        displayName: 'متابَع 1',
        avatar: 'https://picsum.photos/50/50?random=3',
        isVerified: true,
        followers: 1000,
        isOnline: true,
        lastSeen: 'نشط الآن',
      ),
      UserModel(
        id: '4',
        username: 'following2',
        displayName: 'متابَع 2',
        avatar: 'https://picsum.photos/50/50?random=4',
        isVerified: false,
        followers: 200,
        isOnline: false,
        lastSeen: 'منذ يوم',
      ),
    ];
  }

  List<UserModel> _getMockSearchResults(String query) {
    final allUsers = [
      ..._getMockFollowers(),
      ..._getMockFollowing(),
      _getMockUser('current'),
    ];
    
    return allUsers
        .where((user) => 
            user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.displayName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<UserModel> _getMockSuggestedUsers() {
    return [
      UserModel(
        id: '5',
        username: 'suggested1',
        displayName: 'مقترح 1',
        avatar: 'https://picsum.photos/50/50?random=5',
        isVerified: false,
        followers: 300,
        isOnline: false,
        lastSeen: 'منذ ساعتين',
      ),
      UserModel(
        id: '6',
        username: 'suggested2',
        displayName: 'مقترح 2',
        avatar: 'https://picsum.photos/50/50?random=6',
        isVerified: true,
        followers: 800,
        isOnline: true,
        lastSeen: 'نشط الآن',
      ),
    ];
  }
}