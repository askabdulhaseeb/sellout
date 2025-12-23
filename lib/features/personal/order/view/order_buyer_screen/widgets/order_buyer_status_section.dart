import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/step_progress_indicator.dart';
import '../../../domain/entities/order_entity.dart';

class OrderBuyerStatusSection extends StatelessWidget {
  const OrderBuyerStatusSection({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    final StatusType rawStatus = orderData.orderStatus;
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

    if (isCancelled) {
      return const SizedBox.shrink();
    }

    return StepProgressIndicator<StatusType>(
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
    );
  }
}
