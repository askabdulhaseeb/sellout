import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppExpansionTileTheme {
  static ExpansionTileThemeData get light => ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        textColor: AppColors.lightTextColor,
        collapsedTextColor: AppColors.lightTextColor,
        iconColor: AppColors.primaryColor,
        collapsedIconColor: AppColors.subtitleLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
        tilePadding: EdgeInsets.zero,
      );

  static ExpansionTileThemeData get dark => ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        textColor: AppColors.darkTextColor,
        collapsedTextColor: AppColors.darkTextColor,
        iconColor: AppColors.primaryColor,
        collapsedIconColor: AppColors.subtitleDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
        tilePadding: EdgeInsets.zero,
      );
}
