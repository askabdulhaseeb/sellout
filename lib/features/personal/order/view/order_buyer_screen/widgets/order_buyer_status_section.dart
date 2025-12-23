import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/step_progress_indicator.dart';
import '../../../domain/entities/order_entity.dart';

class OrderBuyerStatusSection extends StatelessWidget {
  const OrderBuyerStatusSection({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    final StatusType rawStatus = orderData.orderStatus;
    // If the order is cancelled show a clear banner above the indicator.
    final bool isCancelled =
        rawStatus == StatusType.cancelled || rawStatus == StatusType.canceled;

    // Buyer UI displays a 5-step flow. Some backend statuses (like `completed`)
    // should map to the final delivered step for display.
    const List<StatusType> steps = <StatusType>[
      StatusType.pending,
      StatusType.processing,
      StatusType.readyToShip,
      StatusType.shipped,
      StatusType.delivered,
    ];

    final StatusType displayStatus;
    if (rawStatus == StatusType.delivered ||
        rawStatus == StatusType.completed) {
      displayStatus = StatusType.delivered;
    } else if (steps.contains(rawStatus)) {
      displayStatus = rawStatus;
    } else {
      // Fallback for statuses not part of this delivery pipeline.
      displayStatus = StatusType.pending;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isCancelled)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.cancel_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'cancelled'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          StepProgressIndicator<StatusType>(
            stepsStrs: <String>[
              'ordered'.tr(),
              'processing'.tr(),
              'ready'.tr(),
              'shipped'.tr(),
              'delivered'.tr(),
            ],
            title: 'delivery_info'.tr(),
            currentStep: displayStatus,
            steps: steps,
            pointSize: 16,
            checkIconSize: 10,
            lineThickness: 2,
            labelSpacing: 3,
            labelTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
            showStepNumbers: true,
            showCheckOnActive: false,
            showActiveDot: true,
            colorizeLabels: true,
            stepProgress: 1.0,
          ),
      ],
    );
  }
}
