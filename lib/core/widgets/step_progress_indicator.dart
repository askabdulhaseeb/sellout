import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StepProgressIndicator<T> extends StatelessWidget {
  const StepProgressIndicator({
    required this.currentStep,
    required this.steps,
    required this.stepsStrs,
    this.title,
    this.onChanged,
    this.pointSize = 28,
    this.pointBorderRadius = 100,
    super.key,
  });

  final T currentStep;
  final List<T> steps;
  final List<String> stepsStrs;
  final String? title;
  final ValueChanged<T>? onChanged;

  final double pointSize;
  final double pointBorderRadius;

  int _stepToIndex(T step) => steps.indexOf(step) + 1;

  @override
  Widget build(BuildContext context) {
    final int totalSteps = steps.length;
    final int currentIndex = _stepToIndex(currentStep);
    final Color activeColor = AppTheme.primaryColor;
    final Color inactiveColor = Theme.of(context).dividerColor;
    final Color iconColor = AppTheme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (title != null && title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(totalSteps * 2 - 1, (int index) {
            if (index.isEven) {
              final int stepIndex = index ~/ 2;
              final int displayIndex = stepIndex + 1;
              final stepValue = steps[stepIndex];
              final bool isActive = displayIndex == currentIndex;
              final bool isCompleted = displayIndex < currentIndex;
              final Color pointBorderColor =
                  isActive || isCompleted ? activeColor : inactiveColor;
              final Color pointIconColor =
                  isActive || isCompleted ? iconColor : inactiveColor;

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: onChanged == null
                          ? null
                          : () => onChanged!(stepValue),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: pointSize,
                        height: pointSize,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(pointBorderRadius),
                          border: Border.all(color: pointBorderColor, width: 2),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: isCompleted || isActive
                                ? pointIconColor
                                : Colors.transparent,
                            size: pointSize * 0.65,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stepsStrs[stepIndex],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            } else {
              // Always draw a line between icons
              final int stepBefore = (index ~/ 2) + 1;
              final bool isCompleted = stepBefore < currentIndex;

              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.symmetric(
                      horizontal: 2, vertical: pointSize / 2.5),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.primaryColor
                        : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
