import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/language_controller.dart';
import '../notifications/notifications_screen.dart';

class EnhancedSettingsScreen extends StatelessWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final LanguageController languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'account'.tr,
            [
              _buildSettingItem(
                context,
                Icons.person,
                'edit_profile'.tr,
                () {
                  // Navigate to edit profile
                },
              ),
              _buildSettingItem(
                context,
                Icons.security,
                'privacy'.tr,
                () {
                  // Navigate to privacy settings
                },
              ),
              _buildSettingItem(
                context,
                Icons.notifications,
                'notifications'.tr,
                () {
                  Get.to(() => const NotificationsScreen());
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'التطبيق',
            [
              _buildSettingItem(
                context,
                Icons.language,
                'language'.tr,
                () {
                  _showLanguageDialog(context, languageController);
                },
                trailing: Text(
                  languageController.isArabic ? 'العربية' : 'English',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 14,
                  ),
                ),
              ),
              Obx(() => _buildSettingItem(
                context,
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                'theme'.tr,
                () {
                  themeController.toggleTheme();
                },
                trailing: Switch(
                  value: themeController.isDarkMode,
                  onChanged: (value) {
                    themeController.setTheme(value);
                  },
                  activeColor: AppColors.primary,
                ),
              )),
              _buildSettingItem(
                context,
                Icons.storage,
                'التخزين والبيانات',
                () {
                  // Navigate to storage settings
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'الدعم',
            [
              _buildSettingItem(
                context,
                Icons.help,
                'المساعدة والدعم',
                () {
                  // Navigate to help
                },
              ),
              _buildSettingItem(
                context,
                Icons.info,
                'حول التطبيق',
                () {
                  _showAboutDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.feedback,
                'إرسال ملاحظات',
                () {
                  // Navigate to feedback
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'logout'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              leading: Radio<String>(
                value: 'ar',
                groupValue: controller.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: AppColors.primary,
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: controller.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Bix',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const Text('تطبيق Bix للفيديوهات القصيرة'),
        const SizedBox(height: 8),
        const Text('تطبيق تواصل اجتماعي مبتكر لمشاركة الفيديوهات القصيرة والتفاعل مع المحتوى الإبداعي.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed('/login');
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}