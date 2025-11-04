import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppSwitchTheme {
  static SwitchThemeData get light => SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 12,
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        overlayColor: WidgetStateProperty.all(
          AppColors.primaryColor.withAlpha(26),
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor.withAlpha(115);
          }
          return AppColors.outline;
        }),
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightScaffoldColor;
          }
          return AppColors.lightSurface;
        }),
        // 👇 smaller thumb without icon
        thumbIcon: const WidgetStatePropertyAll(null),
        // 👇 reduce the switch size visually
      );

  static SwitchThemeData get dark => SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 12,
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        overlayColor: WidgetStateProperty.all(
          AppColors.secondaryColor.withAlpha(38),
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor.withAlpha(115);
          }
          return AppColors.darkOutlineVariant;
        }),
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor;
          }
          return AppColors.darkOutline;
        }),
        thumbIcon: const WidgetStatePropertyAll(null),
      );
}
