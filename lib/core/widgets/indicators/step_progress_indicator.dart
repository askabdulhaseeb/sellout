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
    this.showStepNumbers = false,
    this.checkIconSize = 18,
    this.lineThickness = 4,
    this.labelSpacing = 6,
    this.labelTextStyle,
    this.showCheckOnActive = true,
    this.showActiveDot = false,
    this.activeDotSize,
    this.colorizeLabels = false,
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

  /// Whether to show step numbers inside inactive dots.
  ///
  /// When enabled, inactive steps display their 1-based index.
  /// Completed/active steps still show the check icon.
  final bool showStepNumbers;

  /// Size of the check icon inside completed/active dots.
  final double checkIconSize;

  /// Thickness of the connecting line between dots.
  final double lineThickness;

  /// Vertical gap between dot and label.
  final double labelSpacing;

  /// Optional label style override.
  final TextStyle? labelTextStyle;

  /// If true, the active step shows a check icon (legacy behavior).
  ///
  /// For screenshot-like UX, set this to false and enable [showActiveDot].
  final bool showCheckOnActive;

  /// If true, the active step shows a small inner dot.
  final bool showActiveDot;

  /// Optional size override for the active inner dot.
  /// Defaults to ~30% of [pointSize].
  final double? activeDotSize;

  /// If true, step labels are colored based on progress.
  /// Completed/active labels use [color] (or theme primary), upcoming use outline.
  final bool colorizeLabels;

  int _stepToIndex(T step) => steps.indexOf(step) + 1;

  @override
  Widget build(BuildContext context) {
    final int totalSteps = steps.length;
    final int currentIndex = _stepToIndex(currentStep);
    final Color activeColor = color ?? Theme.of(context).primaryColor;
    final Color inactiveColor = Theme.of(context).colorScheme.outlineVariant;
    const Color iconColor = Colors.white;
    final double effectiveActiveDotSize =
        activeDotSize ?? (pointSize * 0.3).clamp(6.0, 12.0);
    final TextStyle? effectiveLabelStyle =
        labelTextStyle ??
        Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500);

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
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.generate(totalSteps * 2 - 1, (int index) {
            if (index.isEven) {
              // DOT
              final int stepIndex = index ~/ 2;
              final int displayIndex = stepIndex + 1;
              final bool isActive = displayIndex == currentIndex;
              final bool isCompleted = displayIndex < currentIndex;
              final bool showCheck =
                  isCompleted || (isActive && showCheckOnActive);
              final bool showDot =
                  isActive && showActiveDot && !showCheckOnActive;

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
                                  if (showStepNumbers &&
                                      !isCompleted &&
                                      !isActive)
                                    Text(
                                      '$displayIndex',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: inactiveColor,
                                          ),
                                    ),
                                  if (showDot)
                                    Container(
                                      width: effectiveActiveDotSize,
                                      height: effectiveActiveDotSize,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: iconColor,
                                      ),
                                    ),
                                  AnimatedOpacity(
                                    opacity: showCheck && value > 0.6 ? 1 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.check_outlined,
                                      color: iconColor,
                                      size: checkIconSize,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                    ),
                    SizedBox(height: labelSpacing),
                    if (stepsStrs.isNotEmpty)
                      Text(
                        stepsStrs[stepIndex],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style:
                            (colorizeLabels
                                ? effectiveLabelStyle?.copyWith(
                                    color: (isCompleted || isActive)
                                        ? activeColor
                                        : inactiveColor,
                                  )
                                : effectiveLabelStyle) ??
                            TextStyle(
                              color:
                                  (colorizeLabels && !(isCompleted || isActive))
                                  ? inactiveColor
                                  : null,
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
                  height: lineThickness,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(lineThickness / 2),
                    child: Stack(
                      children: <Widget>[
                        Container(color: inactiveColor),
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
