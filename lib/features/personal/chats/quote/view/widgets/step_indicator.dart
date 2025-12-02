import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../enums/request_quote_steps.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.currentStep,
    required this.onToggle,
    super.key,
  });

  final RequestQuoteStep currentStep;
  final ValueChanged<RequestQuoteStep> onToggle;

  @override
  Widget build(BuildContext context) {
    const List<RequestQuoteStep> labels = RequestQuoteStep.values;
    final int totalSteps = labels.length;
    final int currentIndex = labels.indexOf(currentStep);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// 🔘 Custom Toggle inside bordered container
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CustomToggleSwitch<RequestQuoteStep>(
              isShaded: false,
              labels: labels,
              labelStrs: labels.map((RequestQuoteStep e) => e.label.tr()).toList(),
              labelText: '',
              onToggle: onToggle,
              initialValue: currentStep,
            ),
          ),

          /// 📊 Progress bar (just like old design)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
              child: LinearProgressIndicator(
                minHeight: 3,
                value: (currentIndex + 1) / totalSteps,
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
