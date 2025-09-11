import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingDeliverySelectionWidget extends StatelessWidget {
  const AddListingDeliverySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Text(
              'delivery'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            // Free Delivery
            _DeliveryTile(
              title: DeliveryType.freeDelivery.code.tr(),
              subtitle: DeliveryType.freeDelivery.subtitle.tr(),
              isSelected: formPro.deliveryType == DeliveryType.freeDelivery,
              onTap: () => formPro.setDeliveryType(DeliveryType.freeDelivery),
            ),
            // Paid Delivery
            _DeliveryTile(
              title: DeliveryType.paid.code.tr(),
              subtitle: DeliveryType.paid.subtitle.tr(),
              isSelected: formPro.deliveryType == DeliveryType.paid,
              onTap: () => formPro.setDeliveryType(DeliveryType.paid),
            ),

            // Show paid delivery fields OUTSIDE of tile
            if (formPro.deliveryType == DeliveryType.paid)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomTextFormField(
                        controller: formPro.localDeliveryFee,
                        keyboardType: TextInputType.number,
                        hint: 'local_delivery_fee'.tr(),
                        prefixText:
                            LocalAuth.currentUser?.currency?.toUpperCase(),
                        contentPadding: EdgeInsets.zero,
                        validator: (String? value) => (value?.isEmpty ?? true)
                            ? 'local_delivery_fee_is_required'.tr()
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextFormField(
                        controller: formPro.internationalDeliveryFee,
                        keyboardType: TextInputType.number,
                        hint: 'international_delivery_fee'.tr(),
                        prefixText:
                            LocalAuth.currentUser?.currency?.toUpperCase(),
                        contentPadding: EdgeInsets.zero,
                        validator: (String? value) => (value?.isEmpty ?? true)
                            ? 'international_delivery_fee_is_required'.tr()
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

            // Collection
            _DeliveryTile(
              title: DeliveryType.collection.code.tr(),
              subtitle: DeliveryType.collection.subtitle.tr(),
              isSelected: formPro.deliveryType == DeliveryType.collection,
              onTap: () => formPro.setDeliveryType(DeliveryType.collection),
            ),
            // Show collection location field OUTSIDE of tile
            if (formPro.deliveryType == DeliveryType.collection)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
                child: NominationLocationField(
                    selectedLatLng: formPro.collectionLatLng,
                    displayMode: MapDisplayMode.showMapAfterSelection,
                    initialText:
                        formPro.selectedCollectionLocation?.address ?? '',
                    onLocationSelected: (LocationEntity p0, LatLng p1) =>
                        formPro.setCollectionLocation(p0, p1)),
              ),
          ],
        );
      },
    );
  }
}

class _DeliveryTile extends StatelessWidget {
  const _DeliveryTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextTheme.of(context).labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : null),
            ),
            Text(subtitle.tr(),
                style: TextTheme.of(context).labelSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorScheme.of(context).outline)),
          ],
        ),
      ),
    );
  }
}
