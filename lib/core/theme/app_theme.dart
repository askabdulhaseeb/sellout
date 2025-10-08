import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'componenets/bottomsheet_theme.dart';
import 'componenets/dailog_theme.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.lightScaffoldColor,
      bottomSheetTheme: AppBottomSheetTheme.light,
      dialogTheme: AppDialogTheme.light,
      shadowColor: Colors.black45,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        outlineVariant: AppColors.outlineVariant,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dividerColor: const Color(0xFFF7F7F7),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightScaffoldColor,
        surfaceTintColor: AppColors.lightScaffoldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.darkScaffoldColor,
      bottomSheetTheme: AppBottomSheetTheme.dark,
      dialogTheme: AppDialogTheme.dark,
      shadowColor: Colors.white30,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.dark,
        outlineVariant: AppColors.outlineVariant,
      ),
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      dividerColor: Colors.white38,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkScaffoldColor,
        surfaceTintColor: AppColors.darkScaffoldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
