import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF0050);
  static const Color secondary = Color(0xFF25F4EE);
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF161823);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8E8E93);
  static const Color darkGrey = Color(0xFF48484A);
  static const Color lightGrey = Color(0xFFC7C7CC);
  
  // Social media colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  
  // Status colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF1744)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}