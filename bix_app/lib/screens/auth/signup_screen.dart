import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main/main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'إنشاء حساب جديد',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // App Logo/Title
            const Text(
              'انضم إلى Bix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Username Field
            CustomTextField(
              controller: _usernameController,
              hintText: 'اسم المستخدم',
              prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            ),
            
            const SizedBox(height: 16),
            
            // Email Field
            CustomTextField(
              controller: _emailController,
              hintText: 'البريد الإلكتروني',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 16),
            
            // Password Field
            CustomTextField(
              controller: _passwordController,
              hintText: 'كلمة المرور',
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              obscureText: true,
            ),
            
            const SizedBox(height: 16),
            
            // Confirm Password Field
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'تأكيد كلمة المرور',
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              obscureText: true,
            ),
            
            const SizedBox(height: 24),
            
            // Sign Up Button
            CustomButton(
              text: 'إنشاء حساب',
              onPressed: _handleSignup,
              isLoading: _isLoading,
            ),
            
            const SizedBox(height: 20),
            
            // Divider
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'أو',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Social Login Buttons
            _buildSocialButton(
              'التسجيل باستخدام فيسبوك',
              Icons.facebook,
              AppColors.facebook,
              () => _handleSocialSignup('facebook'),
            ),
            
            const SizedBox(height: 16),
            
            _buildSocialButton(
              'التسجيل باستخدام Google',
              Icons.g_mobiledata,
              AppColors.google,
              () => _handleSocialSignup('google'),
            ),
            
            const SizedBox(height: 40),
            
            // Terms and Privacy
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'بإنشاء حساب، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'لديك حساب بالفعل؟ ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'تسجيل الدخول',
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

  void _handleSignup() {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate signup process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to main screen
        Get.offAll(() => const MainScreen());
      });
    }
  }

  void _handleSocialSignup(String provider) {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate social signup process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to main screen
      Get.offAll(() => const MainScreen());
    });
  }

  bool _validateForm() {
    if (_usernameController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال اسم المستخدم');
      return false;
    }
    if (_emailController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال البريد الإلكتروني');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال كلمة المرور');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('خطأ', 'كلمات المرور غير متطابقة');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}