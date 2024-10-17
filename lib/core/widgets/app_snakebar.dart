import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSnackBar(
    BuildContext context,
    String message, {
    AnimationStyle? snackBarAnimationStyle,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
        snackBarAnimationStyle: snackBarAnimationStyle,
      );
  }
}
