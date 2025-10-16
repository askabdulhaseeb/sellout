import 'package:flutter/material.dart';

class AppColors {
  // ===== Main Brand Colors =====
  static const Color primaryColor = Color(0xFFBF1017);
  static const Color secondaryColor = Color(0xFF00B49E);
  static const Color accentColor = Color(0xFF00B49E);

  // ===== Backgrounds / Surfaces =====
  static const Color lightScaffoldColor = Colors.white;
  static const Color darkScaffoldColor = Color(0xFF0E0E0E);
  static const Color lightSurface = Color(0xFFF9F9F9);
  static const Color darkSurface = Color(0xFF1C1C1C);
  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF121212);

  // ===== Text Colors =====
  static const Color lightTextColor = Color(0xFF111111);
  static const Color darkTextColor = Color(0xFFEAEAEA);
  static const Color subtitleLight = Color(0xFF5C5C5C);
  static const Color subtitleDark = Color(0xFF9C9C9C);

  // ===== Outline / Borders =====
  static const Color outline = Color(0xFF777777);
  static const Color outlineVariant = Color(0xFFE1E1E1);
  static const Color dividerColor = Color(0xFFE1E1E1);

  // ===== States =====
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // ===== Barriers & Shadows =====
  static const Color barrierColor = Color(0x33000000);
  static const Color lightShadow = Colors.black12;
  static const Color darkShadow = Colors.white10;

  // ===== Light Variants =====
  static const Color myLightPrimaryColor = Color(0xFFFCF3F3);
  static Color lightPrimary = primaryColor.withOpacity(0.05);
}
