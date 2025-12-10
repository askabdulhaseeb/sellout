import 'package:flutter/material.dart';

class StepProgressIndicator<T> extends StatelessWidget {
  const StepProgressIndicator({
    required this.currentStep,
    required this.steps,
    required this.stepsStrs,
    this.color,
    this.title,
    this.onChanged,
    this.pointSize = 32,
    this.pointBorderRadius = 100,
    this.stepProgress = 1.0,
    super.key,
  });

  /// The currently active step
  final T currentStep;

  /// All steps
  final List<T> steps;

  /// Labels
  final List<String> stepsStrs;

  /// Active color
  final Color? color;

  /// Optional title
  final String? title;

  /// Tap callback
  final ValueChanged<T>? onChanged;

  /// Dot size and shape
  final double pointSize;
  final double pointBorderRadius;

  /// How far we’ve progressed filling the current line (0.0–1.0)
  final double stepProgress;

  int _stepToIndex(T step) => steps.indexOf(step) + 1;

  @override
  Widget build(BuildContext context) {
    final int totalSteps = steps.length;
    final int currentIndex = _stepToIndex(currentStep);
    final Color activeColor = color ?? Theme.of(context).primaryColor;
    final Color inactiveColor = Theme.of(context).colorScheme.outlineVariant;
    const Color iconColor = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (title != null && title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(totalSteps * 2 - 1, (int index) {
            if (index.isEven) {
              // DOT
              final int stepIndex = index ~/ 2;
              final int displayIndex = stepIndex + 1;
              final bool isActive = displayIndex == currentIndex;
              final bool isCompleted = displayIndex < currentIndex;

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(
                        begin: 0,
                        end: isCompleted || isActive ? 1 : 0,
                      ),
                      builder:
                          (BuildContext context, double value, Widget? child) {
                            return Container(
                              width: pointSize,
                              height: pointSize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  pointBorderRadius,
                                ),
                                border: Border.all(
                                  color: Color.lerp(
                                    inactiveColor,
                                    activeColor,
                                    value,
                                  )!,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        Colors.transparent,
                                        activeColor,
                                        value,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: value > 0.6 ? 1 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.check_outlined,
                                      color: iconColor,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                    ),
                    const SizedBox(height: 6),
                    if (stepsStrs.isNotEmpty)
                      Text(
                        stepsStrs[stepIndex],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              );
            } else {
              // LINE between dots
              final int leftStepIndex = index ~/ 2 + 1; // step before line
              double fillValue;

              if (currentIndex > leftStepIndex + 1) {
                // Already passed next step — full line
                fillValue = 1.0;
              } else if (currentIndex == leftStepIndex + 1) {
                // We’re currently filling this line
                fillValue = stepProgress.clamp(0.0, 1.0);
              } else {
                fillValue = 0.0;
              }

              return Expanded(
                child: SizedBox(
                  height: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: <Widget>[
                        Container(color: inactiveColor.withOpacity(0.3)),
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 300),
                          widthFactor: fillValue,
                          alignment: Alignment.centerLeft,
                          child: Container(color: activeColor),
                        ),
                      ],
                    ),
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
