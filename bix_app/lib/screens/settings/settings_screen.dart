import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _autoPlayVideos = true;
  bool _saveDataMode = false;
  String _selectedLanguage = 'العربية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account section
            _buildSectionHeader('الحساب'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'إدارة الحساب',
                subtitle: 'تعديل المعلومات الشخصية',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'الخصوصية والأمان',
                subtitle: 'إعدادات الخصوصية وكلمة المرور',
                onTap: () => _showPrivacySettings(),
              ),
              _buildSettingsTile(
                icon: Icons.verified_outlined,
                title: 'طلب التحقق',
                subtitle: 'احصل على علامة التحقق الزرقاء',
                onTap: () {},
              ),
            ]),

            // Notifications section
            _buildSectionHeader('الإشعارات'),
            _buildSettingsGroup([
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'الإشعارات',
                subtitle: 'تلقي إشعارات التطبيق',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _buildSettingsTile(
                icon: Icons.tune,
                title: 'تخصيص الإشعارات',
                subtitle: 'اختر أنواع الإشعارات التي تريد تلقيها',
                onTap: () => _showNotificationSettings(),
              ),
            ]),

            // Display section
            _buildSectionHeader('العرض'),
            _buildSettingsGroup([
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'الوضع المظلم',
                subtitle: 'استخدام المظهر المظلم',
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'اللغة',
                subtitle: _selectedLanguage,
                onTap: () => _showLanguageSettings(),
              ),
            ]),

            // Video settings section
            _buildSectionHeader('إعدادات الفيديو'),
            _buildSettingsGroup([
              _buildSwitchTile(
                icon: Icons.play_circle_outline,
                title: 'تشغيل تلقائي للفيديوهات',
                subtitle: 'تشغيل الفيديوهات تلقائياً عند التمرير',
                value: _autoPlayVideos,
                onChanged: (value) {
                  setState(() {
                    _autoPlayVideos = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.data_saver_on,
                title: 'وضع توفير البيانات',
                subtitle: 'تقليل استهلاك البيانات',
                value: _saveDataMode,
                onChanged: (value) {
                  setState(() {
                    _saveDataMode = value;
                  });
                },
              ),
              _buildSettingsTile(
                icon: Icons.video_settings,
                title: 'جودة الفيديو',
                subtitle: 'اختر جودة الفيديو المفضلة',
                onTap: () => _showVideoQualitySettings(),
              ),
            ]),

            // Storage section
            _buildSectionHeader('التخزين'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.storage,
                title: 'إدارة التخزين',
                subtitle: 'مسح الملفات المؤقتة والتنزيلات',
                onTap: () => _showStorageSettings(),
              ),
              _buildSettingsTile(
                icon: Icons.download,
                title: 'التنزيلات',
                subtitle: 'إدارة الفيديوهات المحفوظة',
                onTap: () {},
              ),
            ]),

            // Support section
            _buildSectionHeader('الدعم'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'مركز المساعدة',
                subtitle: 'الأسئلة الشائعة والدعم',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.feedback_outlined,
                title: 'إرسال ملاحظات',
                subtitle: 'شاركنا رأيك لتحسين التطبيق',
                onTap: () => _showFeedbackDialog(),
              ),
              _buildSettingsTile(
                icon: Icons.bug_report_outlined,
                title: 'الإبلاغ عن مشكلة',
                subtitle: 'أبلغ عن الأخطاء والمشاكل',
                onTap: () {},
              ),
            ]),

            // About section
            _buildSectionHeader('حول التطبيق'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'حول Bix',
                subtitle: 'الإصدار 1.0.0',
                onTap: () => _showAboutDialog(),
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'شروط الخدمة',
                subtitle: 'اقرأ شروط الاستخدام',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                subtitle: 'كيف نحمي بياناتك',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 20),

            // Logout button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات الخصوصية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: const Text('حساب خاص', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.white),
              title: const Text('المستخدمون المحظورون', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.white),
              title: const Text('إخفاء النشاط', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings() {
    // Implementation for notification settings
  }

  void _showLanguageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر اللغة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('العربية', style: TextStyle(color: Colors.white)),
              trailing: _selectedLanguage == 'العربية' 
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = 'العربية';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English', style: TextStyle(color: Colors.white)),
              trailing: _selectedLanguage == 'English' 
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoQualitySettings() {
    // Implementation for video quality settings
  }

  void _showStorageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إدارة التخزين',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.white),
              title: const Text('مسح الملفات المؤقتة', style: TextStyle(color: Colors.white)),
              subtitle: const Text('123 MB', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم مسح الملفات المؤقتة'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cached, color: Colors.white),
              title: const Text('مسح ذاكرة التخزين المؤقت', style: TextStyle(color: Colors.white)),
              subtitle: const Text('456 MB', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم مسح ذاكرة التخزين المؤقت'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'إرسال ملاحظات',
          style: TextStyle(color: Colors.white),
        ),
        content: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'اكتب ملاحظاتك هنا...',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال ملاحظاتك، شكراً لك!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text(
              'إرسال',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'حول Bix',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bix - تطبيق التواصل الاجتماعي',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'الإصدار: 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'تطبيق لمشاركة الفيديوهات القصيرة والتفاعل مع المحتوى الإبداعي.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAll(() => const LoginScreen());
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}