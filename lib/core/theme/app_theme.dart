import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFBF1017);
  static const Color secondaryColor = Color(0xFF00B49E);
  // static const Color accentColor = Color(0xFF00B49E);

  static const Color lightScaffldColor = Colors.white;
  static const Color darkScaffldColor = Colors.black;

  static ThemeData get light {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightScaffldColor,
      dialogTheme: const DialogTheme(
        backgroundColor: lightScaffldColor,
      ),
      shadowColor: Colors.black45,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.light,
      ),
      // brightness: Brightness.light,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dividerColor: Colors.grey[300],
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightScaffldColor,
        surfaceTintColor: lightScaffldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkScaffldColor,
      dialogTheme: const DialogTheme(
        backgroundColor: darkScaffldColor,
      ),
      shadowColor: Colors.white30,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dividerColor: Colors.white38,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkScaffldColor,
        surfaceTintColor: darkScaffldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
