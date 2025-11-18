import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'componenets/app_switch_theme.dart';
import 'componenets/bottomsheet_theme.dart';
import 'componenets/dailog_theme.dart';
import 'componenets/app_appbar_theme.dart';
import 'componenets/app_expansion_tile_theme.dart';
import 'componenets/app_checkbox_theme.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      expansionTileTheme: AppExpansionTileTheme.light,
      checkboxTheme: AppCheckboxTheme.light,
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.lightScaffoldColor,
      cardColor: AppColors.lightCardColor,
      shadowColor: AppColors.lightShadow,
      dividerColor: AppColors.dividerColor,
      switchTheme: AppSwitchTheme.light,
      bottomSheetTheme: AppBottomSheetTheme.light,
      dialogTheme: AppDialogTheme.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryColor,
        onSecondary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextColor,
        // background: AppColors.lightScaffoldColor,
        // onBackground: AppColors.lightTextColor,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.lightShadow,
        scrim: AppColors.barrierColor,
        inversePrimary: AppColors.secondaryColor,
        inverseSurface: AppColors.darkSurface,
      ),
      appBarTheme: AppAppBarTheme.light,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightTextColor,
        ),
        bodyLarge: TextStyle(color: AppColors.lightTextColor, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.subtitleLight, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.subtitleLight, fontSize: 12),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      expansionTileTheme: AppExpansionTileTheme.dark,
      checkboxTheme: AppCheckboxTheme.dark,
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.darkScaffoldColor,
      cardColor: AppColors.darkCardColor,
      shadowColor: AppColors.darkShadow,
      dividerColor: Colors.white12,
      switchTheme: AppSwitchTheme.dark,
      bottomSheetTheme: AppBottomSheetTheme.dark,
      dialogTheme: AppDialogTheme.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryColor,
        onPrimary: Colors.white,
        secondary: AppColors.secondaryColor,
        onSecondary: Colors.black,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextColor,
        // background: AppColors.darkScaffoldColor,
        // onBackground: AppColors.darkTextColor,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        shadow: AppColors.darkShadow,
        scrim: AppColors.barrierColor,
        inversePrimary: AppColors.secondaryColor,
        inverseSurface: AppColors.lightSurface,
      ),
      appBarTheme: AppAppBarTheme.dark,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkTextColor,
        ),
        bodyLarge: TextStyle(color: AppColors.darkTextColor, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.subtitleDark, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.subtitleDark, fontSize: 12),
      ),
    );
  }
}
