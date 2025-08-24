import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'signup_screen.dart';
import '../main/enhanced_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '\$',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // App Logo/Title
            const Text(
              'تسجيل الدخول إلى Bix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 60),
            
            // Email/Phone/Username Field
            CustomTextField(
              controller: _emailController,
              hintText: 'استخدام الهاتف/البريد الإلكتروني/اسم المستخدم',
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
            ),
            
            const SizedBox(height: 20),
            
            // Social Login Buttons
            _buildSocialButton(
              'المتابعة باستخدام فيسبوك',
              Icons.facebook,
              AppColors.facebook,
              () => _handleSocialLogin('facebook'),
            ),
            
            const SizedBox(height: 16),
            
            _buildSocialButton(
              'المتابعة باستخدام Google',
              Icons.g_mobiledata,
              AppColors.google,
              () => _handleSocialLogin('google'),
            ),
            
            const SizedBox(height: 40),
            
            // Create Account Link
            TextButton(
              onPressed: () => Get.to(() => const SignupScreen()),
              child: const Text(
                'حدد حسابًا لتسجيل الدخول',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Terms and Privacy
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'من خلال الاستمرار في استخدام حساب موجود في العراق، فإنك توافق على شروط الخدمة لدينا وتؤكد أنك قد قرأت سياسة الخصوصية.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ليس لديك حساب؟ ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate login process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to main screen
      Get.offAll(() => const EnhancedMainScreen());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}