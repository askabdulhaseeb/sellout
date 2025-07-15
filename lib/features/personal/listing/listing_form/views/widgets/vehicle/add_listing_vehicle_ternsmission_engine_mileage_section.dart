import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/location_field.dart';
import '../../../../../location/data/models/location_model.dart';
import '../../../../../marketplace/domain/entities/location_name_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingVehicleTernsmissionEngineMileageSection
    extends StatelessWidget {
  const AddListingVehicleTernsmissionEngineMileageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              controller: formPro.engineSize,
              labelText: 'Engine Size',
              hint: 'Ex. 1.6',
              keyboardType: TextInputType.number,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.mileage,
                    labelText: 'mileage'.tr(),
                    hint: 'Ex. 10000',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomListingDropDown(
                    hint: 'mileage_unit',
                    categoryKey: 'mileage_unit',
                    selectedValue: formPro.selectedMileageUnit,
                    title: 'mileage_unit',
                    onChanged: formPro.setMileageUnit,
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              controller: formPro.doors,
              labelText: 'doors'.tr(),
              hint: 'Ex. 4',
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              controller: formPro.seats,
              labelText: 'seats'.tr(),
              hint: 'Ex. 5',
              keyboardType: TextInputType.number,
            ),
            LocationField(
              onLocationSelected: (LocationNameEntity location) async {
                final LatLng coords =
                    await formPro.getLocationCoordinates(location.description);
                formPro.setMeetupLocation(LocationModel(
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
          ],
        );
      },
    );
  }
}
