import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingPropertyBedBathWidget extends StatelessWidget {
  const AddListingPropertyBedBathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> propertyTypes =
        LocalCategoriesSource.propertyType ?? <DropdownOptionEntity>[];
    final List<DropdownOptionDataEntity> energyRatings =
        LocalCategoriesSource.clothesBrands ?? <DropdownOptionDataEntity>[];

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bedroom & Bathroom
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.bedroom,
                    validator: (String? value) => AppValidator.isEmpty(value),
                    labelText: 'bedroom'.tr(),
                    hint: 'Ex. 4',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: formPro.bathroom,
                    validator: (String? value) => AppValidator.isEmpty(value),
                    labelText: 'bathroom'.tr(),
                    hint: 'Ex. 3',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Price
            CustomTextFormField(
              controller: formPro.price,
              validator: (String? value) => AppValidator.isEmpty(value),
              labelText: 'price'.tr(),
              hint: 'Ex. 350',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            // Property Type Dropdown
            CustomDropdown<DropdownOptionEntity>(
              items: propertyTypes
                  .map(
                    (DropdownOptionEntity e) =>
                        DropdownMenuItem<DropdownOptionEntity>(
                      value: e,
                      child: Text(e.label),
                    ),
                  )
                  .toList(),
              selectedItem: propertyTypes.first,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'select_category'.tr(),
              onChanged: (DropdownOptionEntity? value) {
                if (value != null) formPro.setPropertyType(value.value.value);
              },
              title: 'category'.tr(),
            ),
            const SizedBox(height: 16),
            // Energy Rating Dropdown
            CustomListingDropDown<AddListingFormProvider,
                DropdownOptionDataEntity>(
              options: energyRatings,
              valueGetter: (DropdownOptionDataEntity opt) => opt.value,
              labelGetter: (DropdownOptionDataEntity opt) => opt.label,
              selectedValue: formPro.selectedEnergyRating,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'energy_rating'.tr(),
              onChanged: (String? value) => formPro.setEnergyRating(value),
              title: 'energy_rating'.tr(),
            ),

            const SizedBox(height: 16),
            // Location Field
            NominationLocationField(
              validator: (bool? value) => AppValidator.requireLocation(value),
              title: 'meetup_location'.tr(),
              selectedLatLng: formPro.collectionLatLng,
              displayMode: MapDisplayMode.showMapAfterSelection,
              initialText: formPro.selectedmeetupLocation?.address ?? '',
              onLocationSelected: (LocationEntity loc, LatLng latLng) =>
                  formPro.setMeetupLocation(loc, latLng),
            ),
          ],
        );
      },
    );
  }
}
