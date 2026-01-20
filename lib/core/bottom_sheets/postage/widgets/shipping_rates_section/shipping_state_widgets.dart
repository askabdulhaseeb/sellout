import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../constants/app_spacings.dart';

/// Widget displayed when there are no shipping rates available
class NoShippingOptionsWidget extends StatelessWidget {
  const NoShippingOptionsWidget({
    required this.cartItemId,
    this.message,
    super.key,
  });

  final String cartItemId;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_shipping_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message ?? 'no_shipping_options_available'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget displayed for free delivery option
class FreeDeliveryWidget extends StatelessWidget {
  const FreeDeliveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'free_delivery_applied'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
