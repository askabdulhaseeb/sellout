import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppBottomSheetTheme {
  static BottomSheetThemeData get light => const BottomSheetThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: Colors.grey, width: 1.2),
        ),
        showDragHandle: true,
      );

  static BottomSheetThemeData get dark => const BottomSheetThemeData(
        backgroundColor: AppColors.darkScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: Colors.white24, width: 1.2),
        ),
        showDragHandle: true,
      );
}
