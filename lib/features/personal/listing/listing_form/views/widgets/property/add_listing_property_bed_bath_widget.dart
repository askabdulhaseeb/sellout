import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../location/data/models/location_model.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';
import '../location_by_name_field.dart';

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
            CustomDynamicDropdown(
              categoryKey: 'property_type',
              selectedValue: formPro.selectedPropertyType,
              onChanged: (String? p0) => formPro.setPropertyType(p0),
              title: 'property_type'.tr(),
            ),
            CustomDynamicDropdown(
                categoryKey: 'energy_rating',
                onChanged: (String? p0) => formPro.setEnergyRating(p0),
                selectedValue: formPro.selectedEnergyRating,
                title: 'energy_rating'.tr()),
            CustomDynamicDropdown(
              categoryKey: 'property_type',
              selectedValue: formPro.selectedPropertyType,
              onChanged: (String? p0) => formPro.setPropertyType(p0),
              title: 'property_type'.tr(),
            ),
            LocationInputField(
              onLocationSelected: (LocationModel location) {
                formPro.setMeetupLocation(location);
              },
              initialLocation: formPro.selectedmeetupLocation,
            ),
          ],
        );
      },
    );
  }
}
