import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFBF1017);

  static ThemeData get light {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.2),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      brightness: Brightness.light,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dividerColor: Colors.grey[200],
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: primaryColor,
      shadowColor: Colors.black.withOpacity(0.2),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
    );
  }
}
