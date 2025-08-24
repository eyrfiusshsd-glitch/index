# معلومات تطبيق Bix

## تفاصيل التطبيق
- **اسم التطبيق**: Bix
- **النوع**: تطبيق تواصل اجتماعي
- **المنصة**: Android
- **حجم APK**: 25.6 MB
- **الإصدار**: 1.0.0
- **تاريخ البناء**: أغسطس 2024

## الشاشات المتوفرة

### 1. شاشة تسجيل الدخول (Login Screen)
- تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
- تسجيل الدخول عبر Facebook
- تسجيل الدخول عبر Google
- رابط للانتقال إلى شاشة التسجيل

### 2. شاشة التسجيل (Signup Screen)
- إنشاء حساب جديد
- التسجيل عبر وسائل التواصل الاجتماعي
- التحقق من صحة البيانات المدخلة

### 3. الشاشة الرئيسية (Home Screen)
- عرض الفيديوهات القصيرة بشكل عمودي
- أزرار الإعجاب والتعليق والمشاركة
- معلومات المستخدم والوصف
- تشغيل تلقائي للفيديوهات

### 4. شاشة البحث (Search Screen)
- البحث عن المستخدمين
- عرض المحتوى الشائع
- فلترة النتائج
- اقتراحات البحث

### 5. شاشة إنشاء الفيديو (Video Creation Screen)
- تسجيل فيديوهات جديدة
- إضافة فلاتر وتأثيرات
- أدوات التحرير
- إضافة النصوص والأوصاف

### 6. شاشة الرسائل (Messages Screen)
- قائمة المحادثات
- إرسال واستقبال الرسائل
- إرسال الصور والملفات
- إشعارات الرسائل الجديدة

### 7. شاشة الملف الشخصي (Profile Screen)
- معلومات المستخدم
- الفيديوهات المنشورة
- المتابعين والمتابعين
- تحرير الملف الشخصي

### 8. شاشة الإعدادات (Settings Screen)
- إعدادات الحساب
- إعدادات الخصوصية
- إعدادات الإشعارات
- إعدادات اللغة والمظهر

## المكونات المخصصة (Custom Widgets)

### 1. CustomButton
- أزرار مخصصة بتصميم موحد
- دعم الألوان والأحجام المختلفة
- تأثيرات الضغط والتفاعل

### 2. CustomTextField
- حقول النص المخصصة
- التحقق من صحة البيانات
- دعم الأيقونات والتلميحات

### 3. VideoPlayerWidget
- مشغل فيديو مخصص
- أزرار التحكم والتفاعل
- عرض معلومات الفيديو

### 4. CommentsBottomSheet
- نافذة التعليقات المنبثقة
- إضافة وعرض التعليقات
- تفاعلات التعليقات

## نماذج البيانات (Data Models)

### 1. UserModel
```dart
class UserModel {
  String id;
  String username;
  String email;
  String displayName;
  String profileImageUrl;
  String bio;
  int followersCount;
  int followingCount;
  int videosCount;
  bool isVerified;
  DateTime createdAt;
}
```

### 2. VideoModel
```dart
class VideoModel {
  String id;
  String userId;
  String videoUrl;
  String thumbnailUrl;
  String description;
  List<String> hashtags;
  int likesCount;
  int commentsCount;
  int sharesCount;
  int viewsCount;
  DateTime createdAt;
  UserModel user;
}
```

### 3. CommentModel
```dart
class CommentModel {
  String id;
  String videoId;
  String userId;
  String text;
  int likesCount;
  DateTime createdAt;
  UserModel user;
  List<CommentModel> replies;
}
```

### 4. MessageModel
```dart
class MessageModel {
  String id;
  String chatId;
  String senderId;
  String receiverId;
  String content;
  MessageType type;
  DateTime timestamp;
  bool isRead;
}
```

## الخدمات (Services)

### 1. AuthService
- إدارة المصادقة والتسجيل
- تسجيل الدخول عبر وسائل التواصل
- إدارة جلسات المستخدم

### 2. VideoService
- رفع وإدارة الفيديوهات
- جلب الفيديوهات للعرض
- إدارة التفاعلات

### 3. UserService
- إدارة بيانات المستخدمين
- البحث عن المستخدمين
- إدارة المتابعة

### 4. MessageService
- إرسال واستقبال الرسائل
- إدارة المحادثات
- الإشعارات الفورية

## الألوان والتصميم

### ألوان التطبيق الرئيسية
- **اللون الأساسي**: #FF0050 (وردي/أحمر)
- **اللون الثانوي**: #000000 (أسود)
- **لون الخلفية**: #FFFFFF (أبيض)
- **لون النص**: #333333 (رمادي داكن)
- **لون Facebook**: #1877F2
- **لون Google**: #DB4437

### خصائص التصميم
- تصميم Material Design
- دعم الوضع الليلي
- واجهة مستخدم عربية
- تصميم متجاوب لجميع الأحجام

## الأذونات المطلوبة

### أذونات Android
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## إعدادات Firebase

### الخدمات المفعلة
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging (للإشعارات)

### قواعد الأمان
- حماية البيانات الشخصية
- التحقق من صحة المستخدم
- تشفير البيانات الحساسة

## الاختبار والجودة

### اختبارات الوحدة
- اختبار نماذج البيانات
- اختبار الخدمات
- اختبار المنطق التجاري

### اختبارات التكامل
- اختبار التفاعل مع Firebase
- اختبار تدفق البيانات
- اختبار واجهة المستخدم

## الأداء والتحسين

### تحسينات الأداء
- تحميل الصور بشكل مؤجل
- ضغط الفيديوهات
- تخزين مؤقت للبيانات
- تحسين استهلاك البطارية

### إدارة الذاكرة
- تنظيف الموارد غير المستخدمة
- إدارة دورة حياة الويدجت
- تحسين استخدام الذاكرة

## المتطلبات التقنية

### الحد الأدنى للمتطلبات
- Android 5.0 (API level 21)
- 2 GB RAM
- 100 MB مساحة تخزين
- اتصال بالإنترنت

### المتطلبات الموصى بها
- Android 8.0 (API level 26) أو أحدث
- 4 GB RAM أو أكثر
- 500 MB مساحة تخزين
- اتصال Wi-Fi أو 4G سريع

---

**ملاحظة**: هذا التطبيق تم تطويره كنموذج أولي ويحتاج إلى اختبارات إضافية قبل النشر في متجر التطبيقات.