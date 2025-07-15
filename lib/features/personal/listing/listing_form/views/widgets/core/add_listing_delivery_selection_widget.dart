import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_radio_button_list_tile.dart';
import '../../../../../../../core/widgets/location_field.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../location/data/models/location_model.dart';
import '../../../../../marketplace/domain/entities/location_name_entity.dart';
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
            subtitle: LocationField(
              onLocationSelected: (LocationNameEntity location) async {
                final LatLng coords =
                    await formPro.getLocationCoordinates(location.description);
                formPro.setCollectionLocation(LocationModel(
                    address: location.structuredFormatting.secondaryText,
                    id: location.placeId,
                    title: location.structuredFormatting.mainText,
                    url:
                        'https://maps.google.com/?q=${coords.latitude},${coords.longitude}',
                    latitude: coords.latitude,
                    longitude: coords.longitude));
              },
              initialText: formPro.selectedmeetupLocation?.address,
            ),

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
