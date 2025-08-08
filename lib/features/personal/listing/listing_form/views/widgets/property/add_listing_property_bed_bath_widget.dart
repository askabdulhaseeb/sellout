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

class AddListingPropertyBedBathWidget extends StatelessWidget {
  const AddListingPropertyBedBathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.bedroom,
                    labelText: 'bedroom'.tr(),
                    hint: 'Ex. 4',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.bathroom,
                    labelText: 'bathroom'.tr(),
                    hint: 'Ex. 3',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              controller: formPro.price,
              labelText: 'price'.tr(),
              hint: 'Ex. 350',
              keyboardType: TextInputType.number,
            ),
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'select_category',
              categoryKey: 'property_type',
              selectedValue: formPro.selectedPropertyType,
              onChanged: (String? p0) => formPro.setPropertyType(p0),
              title: 'category',
            ),
            CustomListingDropDown<AddListingFormProvider>(
                validator: (bool? p0) => null,
                hint: 'energy_rating',
                categoryKey: 'energy_rating',
                onChanged: (String? p0) => formPro.setEnergyRating(p0),
                selectedValue: formPro.selectedEnergyRating,
                title: 'energy_rating'),
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
