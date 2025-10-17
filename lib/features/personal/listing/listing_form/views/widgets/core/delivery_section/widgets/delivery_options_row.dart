import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../core/enums/listing/core/delivery_type.dart';

class DeliveryOptionsRow extends StatelessWidget {
  const DeliveryOptionsRow({
    required this.selectedType,
    required this.onDeliveryTypeSelected,
    super.key,
  });

  final DeliveryType selectedType;
  final ValueChanged<DeliveryType> onDeliveryTypeSelected;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Row(
      spacing: AppSpacing.hXs,
      children: <Widget>[
        Expanded(
          child: _DeliveryOptionTile(
            icon: Icons.local_shipping_outlined,
            title: 'postage'.tr(),
            subtitle: 'ship_tracked_courier'.tr(),
            isSelected: selectedType != DeliveryType.collection,
            color: primaryColor,
            onTap: () => onDeliveryTypeSelected(DeliveryType.paid),
          ),
        ),
        Expanded(
          child: _DeliveryOptionTile(
            icon: Icons.storefront_outlined,
            title: 'collection'.tr(),
            subtitle: 'meet_and_handover_item'.tr(),
            isSelected: selectedType == DeliveryType.collection,
            color: primaryColor,
            onTap: () => onDeliveryTypeSelected(DeliveryType.collection),
          ),
        ),
      ],
    );
  }
}

class _DeliveryOptionTile extends StatelessWidget {
  const _DeliveryOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color activeColor = color ?? scheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      splashColor: activeColor.withValues(alpha: 0.1),
      highlightColor: activeColor.withValues(alpha: 0.05),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? activeColor : scheme.outlineVariant,
            width: 1.4,
          ),
          color: isSelected
              ? activeColor.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
        child: Row(
          spacing: AppSpacing.hSm,
          children: <Widget>[
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : scheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : scheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            Expanded(
              child: Column(
                spacing: AppSpacing.vXs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? activeColor : null,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
