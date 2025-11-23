import 'dart:ui';
import 'package:flutter/material.dart';

import '../../routes/app_linking.dart';
import '../constants/app_spacings.dart';

/// A professional, animated snackbar with a solid background
/// and smooth progress indicator using the app's ColorScheme and spacing.

class AppSnackBar {
  // Global messenger key so we can show snackbars without a local BuildContext
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Resolve a context that’s always available (root navigator context)
  static BuildContext? _rootContext() =>
      AppNavigator().navigatorKey.currentContext;

  static void showSnackBar(
    BuildContext context,
    String message, {
    IconData icon = Icons.info_outline_rounded,
    Color? color,
    Duration duration = const Duration(milliseconds: 2500),
    bool dismissible = true,
  }) {
    // Prefer the provided context, but fall back to the root navigator context
    final BuildContext ctx =
        context.mounted ? context : (_rootContext() ?? context);

    final ThemeData theme = Theme.of(ctx);
    final ColorScheme scheme = theme.colorScheme;
    // Prefer a subtle surface container by default; specific helpers pass container colors
    final Color background = color ?? scheme.surfaceContainerHigh;
    final double screenWidth = MediaQuery.of(ctx).size.width;
    // Pick readable text color based on known theme pairings or luminance
    Color textColor;
    if (color == scheme.primaryContainer) {
      textColor = scheme.onPrimaryContainer;
    } else if (color == scheme.secondaryContainer) {
      textColor = scheme.onSecondaryContainer;
    } else if (color == scheme.tertiaryContainer) {
      textColor = scheme.onTertiaryContainer;
    } else if (color == scheme.errorContainer) {
      textColor = scheme.onErrorContainer;
    } else if (color == scheme.primary) {
      textColor = scheme.onPrimary;
    } else if (color == scheme.secondary) {
      textColor = scheme.onSecondary;
    } else if (color == scheme.tertiary) {
      textColor = scheme.onTertiary;
    } else if (color == scheme.surface ||
        color == scheme.surfaceContainerHigh ||
        color == null) {
      textColor = scheme.onSurface;
    } else {
      textColor =
          background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.maybeOf(ctx) ??
        messengerKey.currentState ??
        ScaffoldMessenger.of(ctx);

    messenger
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
                              tween: Tween<double>(begin: 1, end: 0),
                              duration:
                                  duration - const Duration(milliseconds: 300),
                              builder: (BuildContext context,
                                  double progressValue, _) {
                                return LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    textColor.withValues(alpha: 0.12),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        message,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                        ),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Close Button
                              if (dismissible)
                                GestureDetector(
                                  onTap: () => messenger.hideCurrentSnackBar(),
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

  // --- Contextless API ---
  // These helpers use the global ScaffoldMessenger/Root Navigator context,
  // so you don't need to pass a BuildContext.

  static void show(
    String message, {
    IconData icon = Icons.info_outline_rounded,
    Color? color,
    Duration duration = const Duration(milliseconds: 2500),
    bool dismissible = true,
  }) {
    final BuildContext? ctx = messengerKey.currentContext ?? _rootContext();
    if (ctx == null) return; // App not ready yet
    showSnackBar(
      ctx,
      message,
      icon: icon,
      color: color,
      duration: duration,
      dismissible: dismissible,
    );
  }

  static void successGlobal(String message, {bool dismissible = true}) {
    final BuildContext? ctx = messengerKey.currentContext ?? _rootContext();
    final Color? color = ctx != null
        ? Theme.of(ctx).colorScheme.secondaryContainer
        : Colors.green;
    show(
      message,
      icon: Icons.check_circle_rounded,
      color: color,
      duration: const Duration(milliseconds: 2200),
      dismissible: dismissible,
    );
  }

  static void errorGlobal(String message, {bool dismissible = true}) {
    final BuildContext? ctx = messengerKey.currentContext ?? _rootContext();
    final Color color = ctx != null
        ? Theme.of(ctx).colorScheme.errorContainer
        : Colors.redAccent;
    show(
      message,
      icon: Icons.error_outline_rounded,
      color: color,
      duration: const Duration(milliseconds: 2600),
      dismissible: dismissible,
    );
  }

  static void warningGlobal(String message, {bool dismissible = true}) {
    final BuildContext? ctx = messengerKey.currentContext ?? _rootContext();
    final Color? color = ctx != null
        ? Theme.of(ctx).colorScheme.tertiaryContainer
        : Colors.amber;
    show(
      message,
      icon: Icons.warning_amber_rounded,
      color: color,
      duration: const Duration(milliseconds: 2600),
      dismissible: dismissible,
    );
  }

  static void infoGlobal(String message, {bool dismissible = true}) {
    final BuildContext? ctx = messengerKey.currentContext ?? _rootContext();
    final Color? color = ctx != null
        ? Theme.of(ctx).colorScheme.primaryContainer
        : Colors.blueAccent;
    show(
      message,
      icon: Icons.info_outline_rounded,
      color: color,
      duration: const Duration(milliseconds: 2500),
      dismissible: dismissible,
    );
  }

  // --- Predefined Types ---
  static void success(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.check_circle_rounded,
        color: Theme.of(context).colorScheme.secondaryContainer,
        dismissible: dismissible,
      );

  static void error(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.error_outline_rounded,
        color: Theme.of(context).colorScheme.errorContainer,
        dismissible: dismissible,
      );

  static void warning(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        dismissible: dismissible,
      );

  static void info(BuildContext context, String message,
          {bool dismissible = true}) =>
      showSnackBar(
        context,
        message,
        icon: Icons.info_outline_rounded,
        color: Theme.of(context).colorScheme.primaryContainer,
        dismissible: dismissible,
      );
}
