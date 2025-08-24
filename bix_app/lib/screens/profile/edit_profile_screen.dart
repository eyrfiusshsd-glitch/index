import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  
  String _avatarUrl = 'https://picsum.photos/150/150?random=profile';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    _usernameController.text = 'bix_user';
    _displayNameController.text = 'مستخدم Bix';
    _bioController.text = 'مرحباً بكم في ملفي الشخصي! 🎬\nأحب إنشاء المحتوى الإبداعي';
    _websiteController.text = 'https://bix.app';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'حفظ',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white, size: 50),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Username field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اسم المستخدم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'اسم المستخدم',
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Display name field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الاسم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _displayNameController,
                  hintText: 'الاسم الكامل',
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Bio field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'النبذة التعريفية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _bioController,
                  hintText: 'اكتب نبذة عنك...',
                  maxLines: 3,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Website field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الموقع الإلكتروني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _websiteController,
                  hintText: 'https://example.com',
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Additional options
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Colors.white),
                    title: const Text(
                      'حساب خاص',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // Handle privacy toggle
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  ListTile(
                    leading: const Icon(Icons.verified_outlined, color: Colors.white),
                    title: const Text(
                      'طلب التحقق',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    onTap: () {
                      // Handle verification request
                    },
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  ListTile(
                    leading: const Icon(Icons.business_outlined, color: Colors.white),
                    title: const Text(
                      'التبديل إلى حساب تجاري',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    onTap: () {
                      // Handle business account
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Save button
            CustomButton(
              text: 'حفظ التغييرات',
              onPressed: _saveProfile,
              isLoading: _isLoading,
            ),
            
            const SizedBox(height: 20),
            
            // Delete account
            TextButton(
              onPressed: _showDeleteAccountDialog,
              child: const Text(
                'حذف الحساب',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfilePicture() {
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
          children: [
            const Text(
              'تغيير صورة الملف الشخصي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('التقاط صورة', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('اختيار من المعرض', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف الصورة الحالية', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _avatarUrl = 'https://picsum.photos/150/150?random=default';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        // In a real app, you would upload the image to your server
        // For now, we'll just update the UI
        setState(() {
          _avatarUrl = 'https://picsum.photos/150/150?random=${DateTime.now().millisecondsSinceEpoch}';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث صورة الملف الشخصي'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الصورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveProfile() {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التغييرات بنجاح'),
            backgroundColor: AppColors.primary,
          ),
        );
        
        Navigator.pop(context);
      });
    }
  }

  bool _validateForm() {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال اسم المستخدم'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_displayNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال الاسم'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'حذف الحساب',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هل أنت متأكد من أنك تريد حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.',
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
              // Handle account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلب حذف الحساب'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}