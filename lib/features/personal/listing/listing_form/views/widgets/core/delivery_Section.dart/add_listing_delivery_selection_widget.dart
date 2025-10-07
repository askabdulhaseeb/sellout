import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../location/domain/entities/location_entity.dart';
import '../../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../providers/add_listing_form_provider.dart';
import 'package_delivery_card.dart';

class AddListingDeliverySelectionWidget extends StatelessWidget {
  const AddListingDeliverySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DeliveryOptionTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'postage'.tr(),
                    subtitle: 'ship_tracked_courier'.tr(),
                    isSelected: formPro.deliveryType != DeliveryType.collection,
                    color: AppTheme.primaryColor,
                    onTap: () => formPro.setDeliveryType(DeliveryType.paid),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: DeliveryOptionTile(
                    icon: Icons.storefront_outlined,
                    title: 'collection'.tr(),
                    subtitle: 'meet_and_handover_item'.tr(),
                    isSelected: formPro.deliveryType == DeliveryType.collection,
                    color: AppTheme.primaryColor,
                    onTap: () =>
                        formPro.setDeliveryType(DeliveryType.collection),
                  ),
                ),
              ],
            ),
            // --- Package Details (only when postage selected) ---
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: formPro.deliveryType == DeliveryType.collection
                    ? const AddListingDeliveryCollectionLocationWidget()
                    : const AddListingDeliveryChargesAndCourierWidget()),
          ],
        );
      },
    );
  }
}

class AddListingDeliveryCollectionLocationWidget extends StatelessWidget {
  const AddListingDeliveryCollectionLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
              Widget? child) =>
          Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
        child: NominationLocationField(
            validator: (bool? p0) => AppValidator.requireLocation(p0),
            selectedLatLng: formPro.collectionLatLng,
            displayMode: MapDisplayMode.showMapAfterSelection,
            initialText: formPro.selectedCollectionLocation?.address ?? '',
            onLocationSelected: (LocationEntity p0, LatLng p1) =>
                formPro.setCollectionLocation(p0, p1)),
      ),
    );
  }
}

class AddListingDeliveryChargesAndCourierWidget extends StatelessWidget {
  const AddListingDeliveryChargesAndCourierWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro,
              Widget? child) =>
          Column(
        children: <Widget>[
          ShadowContainer(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(4),
            child: CustomToggleSwitch<DeliveryPayer>(
              widgetMargin: 0,
              solidbgColor: true,
              initialValue: formPro.deliveryPayer,
              isShaded: false,
              unseletedBorderColor: Colors.transparent,
              unseletedTextColor: ColorScheme.of(context).outline,
              labels: const <DeliveryPayer>[
                DeliveryPayer.buyerPays,
                DeliveryPayer.sellerPays,
              ],
              labelStrs: DeliveryPayer.values
                  .map((DeliveryPayer e) => e.code.tr())
                  .toList(),
              labelText: '',
              onToggle: (DeliveryPayer selected) {
                formPro.setDeliveryPayer(selected);
              },
            ),
          ),
          const PackageDetailsCard(),
        ],
      ),
    );
  }
}

/// 🔘 Delivery Option Tile — used for Postage / Collection buttons
class DeliveryOptionTile extends StatelessWidget {
  const DeliveryOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.color,
    super.key,
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
      borderRadius: BorderRadius.circular(14),
      splashColor: activeColor.withValues(alpha: 0.1),
      highlightColor: activeColor.withValues(alpha: 0.05),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : scheme.outlineVariant,
            width: 1.4,
          ),
          color: isSelected
              ? activeColor.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
        child: Row(
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
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? activeColor : null,
                        ),
                  ),
                  const SizedBox(height: 2),
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

enum DeliveryPayer {
  buyerPays(code: 'buyer_pays', jsonKey: 'buyerPays'),
  sellerPays(code: 'seller_pays', jsonKey: 'sellerPays');

  const DeliveryPayer({required this.code, required this.jsonKey});

  final String code;
  final String jsonKey;

  /// Convert from JSON
  static DeliveryPayer fromJson(String value) {
    return DeliveryPayer.values.firstWhere(
      (DeliveryPayer e) => e.jsonKey == value,
      orElse: () => DeliveryPayer.buyerPays,
    );
  }

  /// Convert to JSON
  String toJson() => jsonKey;

  /// For localization
  String get localized => code.tr();
}
