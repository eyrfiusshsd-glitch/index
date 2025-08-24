import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/enhanced_main_screen.dart';
import 'constants/app_colors.dart';
import 'controllers/theme_controller.dart';
import 'controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for demo purposes
  }
  
  // Initialize controllers
  Get.put(ThemeController());
  Get.put(LanguageController());
  
  runApp(const BixApp());
}

class BixApp extends StatelessWidget {
  const BixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bix',
      debugShowCheckedModeBanner: false,
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: ThemeMode.system,
      translations: AppTranslations(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
      home: const IntroScreen(),
      getPages: [
        GetPage(name: '/intro', page: () => const IntroScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/main', page: () => const EnhancedMainScreen()),
      ],
    );
  }
}