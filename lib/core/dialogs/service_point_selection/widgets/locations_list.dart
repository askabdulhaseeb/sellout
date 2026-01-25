import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';
import '../../../constants/app_spacings.dart';
import '../enums/service_point_enums.dart';
import 'location_card.dart';

/// List view of service point locations with loading and empty states
class LocationsList extends StatelessWidget {
  const LocationsList({
    required this.servicePoints,
    required this.selectedPoint,
    required this.selectedCategory,
    required this.onLocationTap,
    required this.isLoading,
    super.key,
  });

  final List<ServicePointModel> servicePoints;
  final ServicePointModel? selectedPoint;
  final ServicePointCategory selectedCategory;
  final ValueChanged<ServicePointModel> onLocationTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Show loading state
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'finding_pickup_locations'.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (servicePoints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'no_locations_found'.tr(
                namedArgs: <String, String>{'category': selectedCategory.key},
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'try_different_category'.tr(),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Show list of locations
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: servicePoints.length,
      itemBuilder: (BuildContext context, int index) {
        final ServicePointModel point = servicePoints[index];
        return LocationCard(
          point: point,
          isSelected: selectedPoint?.id == point.id,
          onTap: () => onLocationTap(point),
        );
      },
    );
  }
}
