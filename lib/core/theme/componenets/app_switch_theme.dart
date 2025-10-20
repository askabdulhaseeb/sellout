import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppSwitchTheme {
  static SwitchThemeData get light => SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 16,
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        overlayColor: WidgetStateProperty.all(
          AppColors.primaryColor.withAlpha(26), // ~10% opacity
        ),
        padding: const EdgeInsets.all(0),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor.withAlpha(115); // active ~45%
          }
          return AppColors.outline; // inactive track color
        }),
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightScaffoldColor; // active thumb
          }
          return AppColors.lightSurface; // inactive thumb
        }),
        thumbIcon: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.circle, size: 14, color: Colors.white);
          }
          return const Icon(
            Icons.circle_outlined,
            size: 12,
            color: Colors.white70,
          );
        }),
      );

  static SwitchThemeData get dark => SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 16,
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        overlayColor: WidgetStateProperty.all(
          AppColors.secondaryColor.withAlpha(38), // ~15% opacity
        ),
        padding: const EdgeInsets.all(0),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: const WidgetStatePropertyAll<double>(0),
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor.withAlpha(115); // active ~45%
          }
          return AppColors.darkOutlineVariant; // inactive track background hint
        }),
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryColor; // active thumb
          }
          return AppColors.darkOutline; // inactive thumb contrast on dark
        }),
        thumbIcon: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(
              Icons.circle,
              size: 14,
              color: AppColors.darkScaffoldColor,
            );
          }
          return const Icon(
            Icons.circle_outlined,
            size: 12,
            color: AppColors.darkScaffoldColor,
          );
        }),
      );
}
