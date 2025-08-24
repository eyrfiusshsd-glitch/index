import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controllers/language_controller.dart';
import 'enhanced_home_screen.dart';
import '../search/new_search_screen.dart';
import '../video_creation/video_creation_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/enhanced_profile_screen.dart';

class EnhancedMainScreen extends StatefulWidget {
  const EnhancedMainScreen({super.key});

  @override
  State<EnhancedMainScreen> createState() => _EnhancedMainScreenState();
}

class _EnhancedMainScreenState extends State<EnhancedMainScreen> {
  int _currentIndex = 0;
  final LanguageController _languageController = Get.find<LanguageController>();
  
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const EnhancedHomeScreen(),
      const NewSearchScreen(),
      const VideoCreationScreen(),
      const MessagesScreen(),
      const EnhancedProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 28,
              ),
              label: _languageController.isArabic ? 'الرئيسية' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.search : Icons.search_outlined,
                size: 28,
              ),
              label: _languageController.isArabic ? 'البحث' : 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currentIndex == 2 ? AppColors.primary : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: _currentIndex == 2 ? Colors.white : Colors.grey,
                  size: 20,
                ),
              ),
              label: _languageController.isArabic ? 'إنشاء' : 'Create',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(
                    _currentIndex == 3 ? Icons.message : Icons.message_outlined,
                    size: 28,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              label: _languageController.isArabic ? 'الرسائل' : 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 4 ? Icons.person : Icons.person_outline,
                size: 28,
              ),
              label: _languageController.isArabic ? 'الملف الشخصي' : 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}