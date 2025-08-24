import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserSession(credential.user);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع: $e';
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user profile
      await credential.user?.updateDisplayName(displayName);
      
      await _saveUserSession(credential.user);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع: $e';
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserSession(userCredential.user);
      return userCredential;
    } catch (e) {
      throw 'فشل تسجيل الدخول بـ Google: $e';
    }
  }

  // Sign in with Facebook (mock implementation)
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // This is a mock implementation
      // In a real app, you would integrate with Facebook SDK
      await Future.delayed(const Duration(seconds: 2));
      
      // Create a mock user for demonstration
      final mockUser = await _createMockUser('facebook_user@example.com', 'Facebook User');
      return mockUser;
    } catch (e) {
      throw 'فشل تسجيل الدخول بـ Facebook: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _clearUserSession();
    } catch (e) {
      throw 'فشل تسجيل الخروج: $e';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'فشل إرسال رابط إعادة تعيين كلمة المرور: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
      }
    } catch (e) {
      throw 'فشل تحديث الملف الشخصي: $e';
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.delete();
        await _clearUserSession();
      }
    } catch (e) {
      throw 'فشل حذف الحساب: $e';
    }
  }

  // Private methods
  Future<void> _saveUserSession(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
      await prefs.setString('user_email', user.email ?? '');
      await prefs.setString('user_name', user.displayName ?? '');
      await prefs.setBool('is_logged_in', true);
    }
  }

  Future<void> _clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<UserCredential?> _createMockUser(String email, String displayName) async {
    // This is a mock implementation for demonstration
    // In a real app, you would handle this properly
    return null;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'لا يوجد مستخدم بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات المسموح، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      default:
        return 'حدث خطأ في المصادقة: ${e.message}';
    }
  }

  // Get user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (isLoggedIn) {
        return {
          'user_id': prefs.getString('user_id'),
          'user_email': prefs.getString('user_email'),
          'user_name': prefs.getString('user_name'),
          'is_logged_in': isLoggedIn,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}