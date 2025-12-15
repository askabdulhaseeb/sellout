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
    // Map processing / readyToShip into the pending step so they
    // display under the same initial step in the UI. If the
    // order is cancelled show a clear banner above the indicator.
    final StatusType rawStatus = orderData.orderStatus;
    final StatusType displayStatus =
        (rawStatus == StatusType.processing ||
            rawStatus == StatusType.readyToShip)
        ? StatusType.pending
        : rawStatus;
    final bool isCancelled = rawStatus == StatusType.cancelled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isCancelled)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  size: 16,
                  color: Theme.of(context).colorScheme.onError,
                ),
                const SizedBox(width: 8),
                Text(
                  'cancelled'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        if (isCancelled) const SizedBox(height: 8),
        StepProgressIndicator<StatusType>(
          stepsStrs: <String>[
            'pending'.tr(),
            'dispatched'.tr(),
            'delivered'.tr(),
          ],
          title: 'delivery_info'.tr(),
          currentStep: displayStatus,
          steps: const <StatusType>[
            StatusType.pending,
            StatusType.shipped,
            StatusType.completed,
          ],
        ),
      ],
    );
  }
}
