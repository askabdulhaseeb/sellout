import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../constants/app_spacings.dart';

/// Widget for selecting who pays for delivery postage
/// Shows toggle between "Buyer pays" and "Seller pays"
class DeliveryPayerWidget extends StatelessWidget {
  const DeliveryPayerWidget({
    required this.isPaidByBuyer,
    required this.onPayerSelected,
    super.key,
  });

  final bool isPaidByBuyer;
  final ValueChanged<bool> onPayerSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'who_pays_for_postage'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          spacing: AppSpacing.sm,
          children: <Widget>[
            Expanded(
              child: _PayerButton(
                label: 'buyer_pays'.tr(),
                isSelected: isPaidByBuyer,
                onPressed: () => onPayerSelected(true),
              ),
            ),
            Expanded(
              child: _PayerButton(
                label: 'seller_pays'.tr(),
                isSelected: !isPaidByBuyer,
                onPressed: () => onPayerSelected(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual payer button component
class _PayerButton extends StatelessWidget {
  const _PayerButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
