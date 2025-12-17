import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // no instances

  // Brand
  static const Color primaryBlue = Color(0xFF0056B3); // #0056B3
  static const Color accentOrange = Color(0xFFFF6F3C); // #FF6F3C

  // Backgrounds
  static const Color bgOffWhite = Color(0xFFF6F7FF);
  static const Color scaffoldLight = bgOffWhite;
  static const Color scaffoldDark = Color(0xFF0B0D0F);

  // Neutrals
  static const Color neutralBlack = Color(0xFF111111);
  static const Color neutral90 = Color(0xFF1F2937);
  static const Color neutral70 = Color(0xFF6B7280);
  static const Color neutral40 = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);

  // States
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Glass tints (used for subtle frosted backgrounds)
  static const Color glassTintLight = Color(0xFFFFFFFF);
  static const Color glassTintSoftBlue = Color(0xFFF1F8FF);
  static const Color glassTintDark = Color(0xFF0F1720);

  // Utility
  static const Color transparent = Colors.transparent;
}