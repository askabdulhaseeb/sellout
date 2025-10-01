import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.currentStep,
    super.key,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final List<String> steps = <String>[
      'select_services',
      'schedule',
      'notes',
      'review',
    ];

    final int totalSteps = steps.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// Steps row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              children: List.generate(steps.length, (int index) {
                final bool isActive = index == currentStep;
                final bool isCompleted = index < currentStep;

                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : isCompleted
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.outlineVariant,
                        width: 1.3,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          steps[index].tr(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            letterSpacing: 0.2,
                            color: isActive
                                ? Theme.of(context).primaryColor
                                : isCompleted
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          /// Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
              child: LinearProgressIndicator(
                minHeight: 3,
                value: (currentStep + 1) / totalSteps,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.4),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
