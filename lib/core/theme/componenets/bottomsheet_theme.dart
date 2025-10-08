import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppBottomSheetTheme {
  static BottomSheetThemeData get light => const BottomSheetThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      );

  static BottomSheetThemeData get dark => const BottomSheetThemeData(
        backgroundColor: AppColors.darkScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      );
}
