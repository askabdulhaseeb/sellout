import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppDialogTheme {
  static DialogThemeData get light => DialogThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        surfaceTintColor: AppColors.lightScaffoldColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.outlineVariant,
            width: 1.2,
          ),
        ),
        shadowColor: Colors.black26,
      );

  static DialogThemeData get dark => DialogThemeData(
        backgroundColor: AppColors.darkScaffoldColor,
        surfaceTintColor: AppColors.darkScaffoldColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.outlineVariant,
            width: 1.2,
          ),
        ),
        shadowColor: Colors.white12,
      );
}
