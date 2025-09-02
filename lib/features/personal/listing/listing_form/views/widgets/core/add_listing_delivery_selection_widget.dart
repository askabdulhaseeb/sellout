import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_radio_button_list_tile.dart';
import '../../../../../../../core/widgets/leaflet_map_field.dart';
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          Text(
            'delivery'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          CustomRadioButtonListTile<DeliveryType>(
            title: DeliveryType.freeDelivery.code.tr(),
            selectedValue: formPro.deliveryType,
            value: DeliveryType.freeDelivery,
            onChanged: formPro.setDeliveryType,
          ),
          CustomRadioButtonListTile<DeliveryType>(
            title: DeliveryType.paid.code.tr(),
            selectedValue: formPro.deliveryType,
            value: DeliveryType.paid,
            onChanged: formPro.setDeliveryType,
            subtitle: Row(
              spacing: 6,
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.localDeliveryFee,
                    keyboardType: TextInputType.number,
                    hint: 'local_delivery_fee'.tr(),
                    // prefixText: LocalState.getCurrency(),
                    prefixText: LocalAuth.currentUser?.currency?.toUpperCase(),
                    contentPadding: EdgeInsets.zero,
                    validator: (String? value) =>
                        formPro.deliveryType == DeliveryType.paid &&
                                (value?.isEmpty ?? true)
                            ? 'local_delivery_fee_is_required'.tr()
                            : null,
                  ),
                ),
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.internationalDeliveryFee,
                    keyboardType: TextInputType.number,
                    hint: 'international_delivery_fee'.tr(),
                    // prefixText: LocalState.getCurrency(),
                    prefixText: LocalAuth.currentUser?.currency?.toUpperCase(),
                    contentPadding: EdgeInsets.zero,
                    validator: (String? value) =>
                        formPro.deliveryType == DeliveryType.paid &&
                                (value?.isEmpty ?? true)
                            ? 'international_delivery_fee_is_required'.tr()
                            : null,
                  ),
                ),
              ],
            ),
          ),
          CustomRadioButtonListTile<DeliveryType>(
              title: DeliveryType.collocation.code.tr(),
              selectedValue: formPro.deliveryType,
              value: DeliveryType.collocation,
              onChanged: formPro.setDeliveryType,
              subtitle: LocationDropdown(
                selectedLatLng: LatLng(
                    formPro.selectedCollectionLocation?.latitude ?? 0,
                    formPro.selectedCollectionLocation?.longitude ?? 0),
                displayMode: MapDisplayMode.neverShowMap,
                initialText: formPro.selectedCollectionLocation?.address ?? '',
                onLocationSelected: (LocationEntity p0, LatLng p1) {
                  formPro.setCollectionLocation(p0);
                },
              )

              //  LocationInputButton(
              //   validator: (bool? value) =>
              //       formPro.deliveryType == DeliveryType.collocation &&
              //               (value == null)
              //           ? 'location_is_required'.tr()
              //           : null,
              // ),
              ),
        ],
      );
    });
  }
}
