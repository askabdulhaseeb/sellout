import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_spacings.dart';

/// A professional, animated snackbar with a solid background
/// and smooth progress indicator using the app's ColorScheme and spacing.
class AppSnackBar {
  static void showSnackBar(
    BuildContext context,
    String message, {
    IconData icon = Icons.info_outline_rounded,
    Color? color,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color background = color ?? scheme.primary;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Color textColor =
        background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          duration: duration,
          padding: EdgeInsets.zero,
          content: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double value, _) {
              final double dropY =
                  -100 * (1 - Curves.elasticOut.transform(value));
              final double expandProgress = Curves.easeOutQuart
                  .transform(((value - 0.25).clamp(0.0, 0.35)) / 0.35);
              final double contentProgress = Curves.easeOutCubic
                  .transform(((value - 0.6).clamp(0.0, 0.4)) / 0.4);

              final double width =
                  lerpDouble(100, screenWidth - AppSpacing.xl, expandProgress)!;
              final BorderRadius borderRadius = BorderRadius.circular(
                lerpDouble(40, 14, expandProgress)!,
              );

              return Transform.translate(
                offset: Offset(0, dropY),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 72,
                    width: width,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: borderRadius,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: background.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        // Progress Indicator (Bottom Bar)
                        if (duration.inSeconds > 2)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 1, end: 0),
                              duration:
                                  duration - const Duration(milliseconds: 300),
                              builder: (BuildContext context,
                                  double progressValue, _) {
                                return LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation(
                                    textColor.withOpacity(0.2),
                                  ),
                                  minHeight: 3,
                                );
                              },
                            ),
                          ),

                        // Snackbar Content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: <Widget>[
                              // Icon
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                                builder:
                                    (BuildContext context, double scale, _) {
                                  return Transform.scale(
                                    scale: 0.8 + 0.2 * scale,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.all(AppSpacing.xs),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.15),
                                      ),
                                      child: Icon(
                                        icon,
                                        color: textColor,
                                        size: 22,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(width: AppSpacing.md),

                              // Message + Time
                              Expanded(
                                child: AnimatedOpacity(
                                  opacity: contentProgress,
                                  duration: const Duration(milliseconds: 400),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        message,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Close Button
                              if (dismissible)
                                GestureDetector(
                                  onTap: () => ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar(),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.xs),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.15),
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: textColor.withOpacity(0.9),
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }

  // --- Predefined Types ---
  static void success(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.check_circle_rounded,
        color: Theme.of(context).colorScheme.tertiary,
        dismissible: dismissible,
      );

  static void error(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
        dismissible: dismissible,
      );

  static void warning(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.secondary,
        dismissible: dismissible,
      );

  static void info(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.info_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
        dismissible: dismissible,
      );
}
