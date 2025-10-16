import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppBottomSheetTheme {
  static BottomSheetThemeData get light => const BottomSheetThemeData(
        backgroundColor: AppColors.lightScaffoldColor,
        surfaceTintColor: AppColors.lightScaffoldColor,
        modalBarrierColor: AppColors.barrierColor, // adds soft overlay
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: AppColors.outlineVariant, width: 1.2),
        ),
        elevation: 6,
        dragHandleColor: AppColors.outline, // subtle grey handle
      );

  static BottomSheetThemeData get dark => BottomSheetThemeData(
        backgroundColor: AppColors.darkScaffoldColor,
        surfaceTintColor: AppColors.darkScaffoldColor,
        modalBarrierColor: AppColors.barrierColor.withOpacity(0.6),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: AppColors.outlineVariant, width: 1.2),
        ),
        elevation: 8,
        dragHandleColor: AppColors.outlineVariant,
      );
}
