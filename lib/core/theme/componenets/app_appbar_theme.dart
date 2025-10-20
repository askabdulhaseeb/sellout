import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppAppBarTheme {
  static AppBarTheme get light => const AppBarTheme(
        backgroundColor: AppColors.lightScaffoldColor,
        surfaceTintColor: AppColors.lightScaffoldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      );

  static AppBarTheme get dark => const AppBarTheme(
        backgroundColor: AppColors.darkScaffoldColor,
        surfaceTintColor: AppColors.darkScaffoldColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      );
}
