import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../core/enums/listing/core/delivery_type.dart';
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
          spacing: AppSpacing.vXs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              spacing: AppSpacing.xs,
              children: <Widget>[
                Expanded(
                  child: DeliveryOptionTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'postage'.tr(),
                    subtitle: 'ship_tracked_courier'.tr(),
                    isSelected: formPro.deliveryType != DeliveryType.collection,
                    color: Theme.of(context).primaryColor,
                    onTap: () => formPro.setDeliveryType(DeliveryType.paid),
                  ),
                ),
                Expanded(
                  child: DeliveryOptionTile(
                    icon: Icons.storefront_outlined,
                    title: 'collection'.tr(),
                    subtitle: 'meet_and_handover_item'.tr(),
                    isSelected: formPro.deliveryType == DeliveryType.collection,
                    color: Theme.of(context).primaryColor,
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
                  : const AddListingDeliveryChargesAndCourierWidget(),
            ),
          ],
        );
      },
    );
  }
}

class AddListingDeliveryCollectionLocationWidget extends StatelessWidget {
  const AddListingDeliveryCollectionLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.hSm,
            vertical: AppSpacing.vXs,
          ),
          child: NominationLocationField(
            validator: (bool? value) => AppValidator.requireLocation(value),
            selectedLatLng: formPro.collectionLatLng,
            displayMode: MapDisplayMode.showMapAfterSelection,
            initialText: formPro.selectedCollectionLocation?.address ?? '',
            onLocationSelected: (LocationEntity location, LatLng latLng) {
              formPro.setCollectionLocation(location, latLng);
            },
          ),
        );
      },
    );
  }
}

class AddListingDeliveryChargesAndCourierWidget extends StatelessWidget {
  const AddListingDeliveryChargesAndCourierWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;

        return Column(
          children: <Widget>[
            ShadowContainer(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.vXs),
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: CustomToggleSwitch<DeliveryPayer>(
                widgetMargin: 0,
                solidbgColor: true,
                initialValue: formPro.deliveryPayer,
                isShaded: false,
                unseletedBorderColor: Colors.transparent,
                unseletedTextColor: colorScheme.outline,
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
        );
      },
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

enum DeliveryPayer {
  buyerPays(code: 'buyer_pays', jsonKey: 'buyerPays'),
  sellerPays(code: 'seller_pays', jsonKey: 'sellerPays');

  const DeliveryPayer({required this.code, required this.jsonKey});

  final String code;
  final String jsonKey;

  static DeliveryPayer fromJson(String value) {
    return DeliveryPayer.values.firstWhere(
      (DeliveryPayer e) => e.jsonKey == value,
      orElse: () => DeliveryPayer.buyerPays,
    );
  }

  String toJson() => jsonKey;

  String get localized => code.tr();
}
