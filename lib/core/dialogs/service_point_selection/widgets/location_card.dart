import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';
import '../../../constants/app_spacings.dart';
import '../../../enums/shipping_provider_enum.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.point,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ServicePointModel point;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            if (isSelected)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Radio<String>(
              value: point.id.toString(),
              groupValue: isSelected ? point.id.toString() : null,
              onChanged: (_) => onTap(),
              activeColor: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    point.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: <Widget>[
                      _buildBadge(point.type, colorScheme.tertiary),
                      _buildBadge(
                        '${point.distance.toString()} km',
                        colorScheme.secondary,
                      ),
                      _buildCarrierBadge(point.carrier, colorScheme.primary),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${point.address}${', ${point.city}'}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: point.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      point.isActive ? 'open_now'.tr() : 'closed'.tr(),
                      style: textTheme.labelSmall?.copyWith(
                        color: point.isActive ? Colors.green : Colors.red,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build carrier badge with text and optional icon
  Widget _buildCarrierBadge(String carrier, Color color) {
    final ShippingProvider provider = getProviderEnum(carrier);
    final String displayText = providerDisplayNames[provider] ?? carrier;
    final IconData icon = _getCarrierIcon(provider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Get icon for carrier type
  IconData _getCarrierIcon(ShippingProvider provider) {
    switch (provider) {
      case ShippingProvider.dhl:
      case ShippingProvider.ups:
      case ShippingProvider.fedex:
      case ShippingProvider.gls:
      case ShippingProvider.dpd:
      case ShippingProvider.postnl:
      case ShippingProvider.usps:
      case ShippingProvider.hermes:
      case ShippingProvider.inpost:
      case ShippingProvider.evri:
      case ShippingProvider.sendcloud:
      case ShippingProvider.shippo:
        return Icons.local_shipping;
      case ShippingProvider.royalmail:
        return Icons.mail;
      case ShippingProvider.other:
        return Icons.local_shipping;
    }
  }
}
