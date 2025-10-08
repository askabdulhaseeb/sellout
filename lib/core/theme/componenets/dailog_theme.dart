import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppDialogTheme {
  static DialogThemeData get light => DialogThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static DialogThemeData get dark => DialogThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );
}
