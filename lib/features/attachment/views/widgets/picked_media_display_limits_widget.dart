import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/picked_media_provider.dart';

class PickedMediaDisplayLimitsWidget extends StatelessWidget {
  const PickedMediaDisplayLimitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        final int selectedCount = provider.pickedMedia.length;
        final int maxCount = provider.option.maxAttachments;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _getContainerColor(context, selectedCount, maxCount),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _getBoxShadow(context, selectedCount, maxCount),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                '$selectedCount/$maxCount',
                key: ValueKey(selectedCount), // Important for animation
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: _getTextColor(context, selectedCount, maxCount),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getContainerColor(
    BuildContext context,
    int selectedCount,
    int maxCount,
  ) {
    if (selectedCount == 0) {
      return Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    } else if (selectedCount < maxCount) {
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.15);
    } else {
      return Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.8);
    }
  }

  Color _getTextColor(BuildContext context, int selectedCount, int maxCount) {
    if (selectedCount == 0) {
      return Theme.of(
        context,
      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    } else if (selectedCount < maxCount) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
  }

  List<BoxShadow>? _getBoxShadow(
    BuildContext context,
    int selectedCount,
    int maxCount,
  ) {
    if (selectedCount == 0) return null;

    return <BoxShadow>[
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        blurRadius: selectedCount == maxCount ? 12 : 6,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
