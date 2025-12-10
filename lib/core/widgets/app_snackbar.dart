import 'package:flutter/material.dart';
import '../../routes/app_linking.dart';

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
    final BuildContext ctx = context.mounted
        ? context
        : (_rootContext() ?? context);
    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.maybeOf(ctx) ??
        messengerKey.currentState ??
        ScaffoldMessenger.of(ctx);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              Icon(icon, color: color ?? Theme.of(ctx).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: color,
          duration: duration,
          behavior: SnackBarBehavior.fixed,
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
    final Color color = ctx != null
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
    final Color color = ctx != null
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
    final Color color = ctx != null
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
  static void success(
    BuildContext context,
    String message, {
    bool dismissible = true,
  }) => showSnackBar(
    context,
    message,
    icon: Icons.check_circle_rounded,
    color: Theme.of(context).colorScheme.secondaryContainer,
    dismissible: dismissible,
  );

  static void error(
    BuildContext context,
    String message, {
    bool dismissible = true,
  }) => showSnackBar(
    context,
    message,
    icon: Icons.error_outline_rounded,
    color: Theme.of(context).colorScheme.errorContainer,
    dismissible: dismissible,
  );

  static void warning(
    BuildContext context,
    String message, {
    bool dismissible = true,
  }) => showSnackBar(
    context,
    message,
    icon: Icons.warning_amber_rounded,
    color: Theme.of(context).colorScheme.tertiaryContainer,
    dismissible: dismissible,
  );

  static void info(
    BuildContext context,
    String message, {
    bool dismissible = true,
  }) => showSnackBar(
    context,
    message,
    icon: Icons.info_outline_rounded,
    color: Theme.of(context).colorScheme.primaryContainer,
    dismissible: dismissible,
  );
}
