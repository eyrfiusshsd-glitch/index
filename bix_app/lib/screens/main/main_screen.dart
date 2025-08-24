import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'enhanced_home_screen.dart';
import '../search/new_search_screen.dart';
import '../video_creation/video_creation_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/enhanced_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const EnhancedHomeScreen(),
    const NewSearchScreen(),
    const VideoCreationScreen(),
    const MessagesScreen(),
    const EnhancedProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 28,
              ),
              label: 'الصفحة الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.search : Icons.search_outlined,
                size: 28,
              ),
              label: 'اكتشف',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 28,
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currentIndex == 2 ? AppColors.primary : Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(
                    _currentIndex == 3 ? Icons.chat_bubble : Icons.chat_bubble_outline,
                    size: 28,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              label: 'صندوق الوارد',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 4 ? Icons.person : Icons.person_outline,
                size: 28,
              ),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }
}