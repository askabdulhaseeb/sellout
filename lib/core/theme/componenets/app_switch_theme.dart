import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppSwitchTheme {
  static SwitchThemeData light = SwitchThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    trackColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.secondaryColor.withValues(alpha: 0.5)
          : Colors.grey.shade400,
    ),
    thumbColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.lightScaffoldColor
          : Colors.grey.shade600,
    ),
  );

  static SwitchThemeData dark = SwitchThemeData(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    trackColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.secondaryColor.withValues(alpha: 0.5)
          : Colors.grey.shade700,
    ),
    thumbColor: WidgetStateProperty.resolveWith(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.darkScaffoldColor
          : Colors.grey.shade400,
    ),
  );
}
