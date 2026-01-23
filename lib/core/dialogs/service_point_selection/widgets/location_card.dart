import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';
import '../../../constants/app_spacings.dart';

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
    // Map carrier to display text and icon
    final String displayText = _getCarrierDisplayText(carrier);
    final IconData? icon = _getCarrierIcon(carrier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
          ],
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

  /// Get display text for carrier
  String _getCarrierDisplayText(String carrier) {
    final String lowerCarrier = carrier.toLowerCase();
    if (lowerCarrier.contains('dhl')) return 'DHL';
    if (lowerCarrier.contains('fedex')) return 'FedEx';
    if (lowerCarrier.contains('ups')) return 'UPS';
    if (lowerCarrier.contains('amazon')) return 'Amazon';
    if (lowerCarrier.contains('gls')) return 'GLS';
    if (lowerCarrier.contains('hermes')) return 'Hermes';
    if (lowerCarrier.contains('royal')) return 'Royal Mail';
    return carrier;
  }

  /// Get icon for carrier type
  IconData? _getCarrierIcon(String carrier) {
    final String lowerCarrier = carrier.toLowerCase();
    if (lowerCarrier.contains('dhl')) return Icons.local_shipping;
    if (lowerCarrier.contains('fedex')) return Icons.local_shipping;
    if (lowerCarrier.contains('ups')) return Icons.local_shipping;
    if (lowerCarrier.contains('amazon')) return Icons.store;
    if (lowerCarrier.contains('gls')) return Icons.local_shipping;
    if (lowerCarrier.contains('hermes')) return Icons.local_shipping;
    if (lowerCarrier.contains('royal')) return Icons.mail;
    return Icons.local_shipping;
  }
}
