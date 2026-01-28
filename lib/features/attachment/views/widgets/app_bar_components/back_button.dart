import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacings.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    required this.onPressed,
    this.isActive = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_rounded),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
      ),
      tooltip: 'Go back',
    );
  }
}
