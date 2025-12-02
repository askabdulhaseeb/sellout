import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppCheckboxTheme {
  static CheckboxThemeData get light => CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryColor;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.primaryColor.withValues(alpha: 0.08),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );

  static CheckboxThemeData get dark => CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryColor;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.primaryColor.withValues(alpha: 0.12),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
}
