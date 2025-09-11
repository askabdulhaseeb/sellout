import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_wrapper.dart';
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
              hint: 'select_category'.tr(),
              categoryKey: 'property_type',
              selectedValue: formPro.selectedPropertyType,
              onChanged: (String? p0) => formPro.setPropertyType(p0),
              title: 'category'.tr(),
            ),
            CustomListingDropDown<AddListingFormProvider>(
                validator: (bool? p0) => null,
                hint: 'energy_rating'.tr(),
                categoryKey: 'energy_rating',
                onChanged: (String? p0) => formPro.setEnergyRating(p0),
                selectedValue: formPro.selectedEnergyRating,
                title: 'energy_rating'.tr()),
            NominationLocationField(
                title: 'meetup_location'.tr(),
                selectedLatLng: formPro.collectionLatLng,
                displayMode: MapDisplayMode.showMapAfterSelection,
                initialText: formPro.selectedmeetupLocation?.address ?? '',
                onLocationSelected: (LocationEntity p0, LatLng p1) =>
                    formPro.setMeetupLocation(p0, p1)),
          ],
        );
      },
    );
  }
}
