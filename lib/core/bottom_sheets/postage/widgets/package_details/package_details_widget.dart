import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../constants/app_spacings.dart';
import 'parcel_option_card.dart';

/// Parcel type model for display
class ParcelOption {
  const ParcelOption({
    required this.id,
    required this.label,
    required this.dimensions,
    required this.icon,
  });

  final String id;
  final String label;
  final String dimensions;
  final IconData icon;
}

/// Widget displaying package details with parcel options
/// Shows different parcel sizes and allows custom parcel entry
class PackageDetailsWidget extends StatelessWidget {
  const PackageDetailsWidget({
    required this.selectedParcelId,
    required this.onParcelSelected,
    required this.onCustomParcelSelected,
    super.key,
  });

  final String? selectedParcelId;
  final ValueChanged<String> onParcelSelected;
  final VoidCallback onCustomParcelSelected;

  static const List<ParcelOption> standardParcels = <ParcelOption>[
    ParcelOption(
      id: 'small',
      label: 'small_parcel',
      dimensions: 'up_to_35x25x2_5cm',
      icon: Icons.mail,
    ),
    ParcelOption(
      id: 'medium',
      label: 'medium_parcel',
      dimensions: 'up_to_45x35x16cm',
      icon: Icons.inventory_2_outlined,
    ),
    ParcelOption(
      id: 'large',
      label: 'large_parcel',
      dimensions: 'up_to_61x46x46cm',
      icon: Icons.inventory,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'package_details'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'ensure_package_not_heavier_or_larger'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RadioGroup<String>(
          groupValue: selectedParcelId,
          onChanged: (String? id) {
            if (id != null) onParcelSelected(id);
          },
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: standardParcels.length + 1, // +1 for custom parcel
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (BuildContext context, int index) {
              if (index < standardParcels.length) {
                final ParcelOption parcel = standardParcels[index];
                return ParcelOptionCard(parcel: parcel);
              } else {
                // Custom Parcel option
                return ParcelOptionCard(
                  parcel: const ParcelOption(
                    id: 'custom',
                    label: 'custom_parcel',
                    dimensions: 'custom_dimensions',
                    icon: Icons.edit,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
