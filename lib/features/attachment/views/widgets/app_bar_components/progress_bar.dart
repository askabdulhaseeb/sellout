import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacings.dart';

class SelectionProgressBar extends StatelessWidget {
  const SelectionProgressBar({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
