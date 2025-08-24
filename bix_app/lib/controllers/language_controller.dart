import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'language_code';
  
  final _currentLanguage = 'ar'.obs;
  String get currentLanguage => _currentLanguage.value;
  
  final _isArabic = true.obs;
  bool get isArabic => _isArabic.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromPrefs();
  }

  void changeLanguage(String languageCode) {
    _currentLanguage.value = languageCode;
    _isArabic.value = languageCode == 'ar';
    
    final locale = Locale(languageCode);
    Get.updateLocale(locale);
    _saveLanguageToPrefs();
  }

  void toggleLanguage() {
    final newLanguage = _isArabic.value ? 'en' : 'ar';
    changeLanguage(newLanguage);
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'ar';
    _currentLanguage.value = languageCode;
    _isArabic.value = languageCode == 'ar';
    
    final locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  Future<void> _saveLanguageToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _currentLanguage.value);
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': {
      // Navigation
      'home': 'الرئيسية',
      'search': 'البحث',
      'create': 'إنشاء',
      'messages': 'الرسائل',
      'profile': 'الملف الشخصي',
      
      // Auth
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login_with_facebook': 'تسجيل الدخول بـ Facebook',
      'login_with_google': 'تسجيل الدخول بـ Google',
      'dont_have_account': 'ليس لديك حساب؟',
      'already_have_account': 'لديك حساب بالفعل؟',
      
      // Home
      'for_you': 'لك',
      'following': 'المتابعون',
      'live': 'مباشر',
      'like': 'إعجاب',
      'comment': 'تعليق',
      'share': 'مشاركة',
      'save': 'حفظ',
      
      // Search
      'search_hint': 'البحث عن المستخدمين والفيديوهات',
      'trending': 'الشائع',
      'users': 'المستخدمون',
      'videos': 'الفيديوهات',
      'hashtags': 'الهاشتاغات',
      
      // Profile
      'edit_profile': 'تعديل الملف الشخصي',
      'followers': 'المتابعون',
      'following': 'المتابعة',
      'likes': 'الإعجابات',
      'videos': 'الفيديوهات',
      'bio': 'النبذة الشخصية',
      'website': 'الموقع الإلكتروني',
      
      // Settings
      'settings': 'الإعدادات',
      'account': 'الحساب',
      'privacy': 'الخصوصية',
      'notifications': 'الإشعارات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_mode': 'الوضع المظلم',
      'light_mode': 'الوضع الفاتح',
      'logout': 'تسجيل الخروج',
      
      // Messages
      'new_message': 'رسالة جديدة',
      'type_message': 'اكتب رسالة...',
      'send': 'إرسال',
      'online': 'متصل',
      'offline': 'غير متصل',
      
      // Notifications
      'notifications': 'الإشعارات',
      'no_notifications': 'لا توجد إشعارات',
      'mark_all_read': 'تحديد الكل كمقروء',
      
      // General
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'yes': 'نعم',
      'no': 'لا',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'retry': 'إعادة المحاولة',
      'done': 'تم',
      'next': 'التالي',
      'previous': 'السابق',
      'skip': 'تخطي',
      'get_started': 'ابدأ الآن',
    },
    'en': {
      // Navigation
      'home': 'Home',
      'search': 'Search',
      'create': 'Create',
      'messages': 'Messages',
      'profile': 'Profile',
      
      // Auth
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'login_with_facebook': 'Login with Facebook',
      'login_with_google': 'Login with Google',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      
      // Home
      'for_you': 'For You',
      'following': 'Following',
      'live': 'Live',
      'like': 'Like',
      'comment': 'Comment',
      'share': 'Share',
      'save': 'Save',
      
      // Search
      'search_hint': 'Search users and videos',
      'trending': 'Trending',
      'users': 'Users',
      'videos': 'Videos',
      'hashtags': 'Hashtags',
      
      // Profile
      'edit_profile': 'Edit Profile',
      'followers': 'Followers',
      'following': 'Following',
      'likes': 'Likes',
      'videos': 'Videos',
      'bio': 'Bio',
      'website': 'Website',
      
      // Settings
      'settings': 'Settings',
      'account': 'Account',
      'privacy': 'Privacy',
      'notifications': 'Notifications',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'logout': 'Logout',
      
      // Messages
      'new_message': 'New Message',
      'type_message': 'Type a message...',
      'send': 'Send',
      'online': 'Online',
      'offline': 'Offline',
      
      // Notifications
      'notifications': 'Notifications',
      'no_notifications': 'No notifications',
      'mark_all_read': 'Mark all as read',
      
      // General
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'done': 'Done',
      'next': 'Next',
      'previous': 'Previous',
      'skip': 'Skip',
      'get_started': 'Get Started',
    },
  };
}