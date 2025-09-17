import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dropdowns/color_dropdown.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../../../marketplace/views/widgets/market_categorized_filters_page_widgets/widgets/vehicle_filter/widget/year_picker_dropdown.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingVehicleBasicInfoSection extends StatefulWidget {
  const AddListingVehicleBasicInfoSection({super.key});

  @override
  State<AddListingVehicleBasicInfoSection> createState() =>
      _AddListingVehicleBasicInfoSectionState();
}

class _AddListingVehicleBasicInfoSectionState
    extends State<AddListingVehicleBasicInfoSection> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> vehiclecatgory =
        LocalCategoriesSource.vehicles ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> fuelType =
        LocalCategoriesSource.fuelType ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> make =
        LocalCategoriesSource.make ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> transmission =
        LocalCategoriesSource.transmission ?? <DropdownOptionEntity>[];
    final List<DropdownOptionEntity> emissionStandards =
        LocalCategoriesSource.emissionStandards ?? <DropdownOptionEntity>[];
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Category
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: vehiclecatgory,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              title: 'category'.tr(),
              hint: 'select_category'.tr(),
              selectedValue: formPro.selectedVehicleCategory,
              onChanged: (String? p0) => formPro.setVehicleCategory(p0),
              validator: (bool? value) => AppValidator.requireSelection(value),
            ),

            /// Year
            CustomYearDropdown(
              hintText: 'year'.tr(),
              title: 'year'.tr(),
              selectedYear: formPro.year,
              onChanged: (String? value) => formPro.setYear(value),
              validator: (bool? value) => AppValidator.requireSelection(value),
            ),

            /// Body type dynamic dropdown
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: vehiclecatgory,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'body_type'.tr(),
              parentValue: formPro.selectedVehicleCategory,
              // categoryKey: 'body_type',
              selectedValue: formPro.selectedBodyType,
              title: 'body_type'.tr(),
              onChanged: (String? value) => formPro.setBodyType(value ?? ''),
            ),

            /// Emission standard dynamic dropdown
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: emissionStandards,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'emission_standards'.tr(),
              // categoryKey: 'emission_standards',
              selectedValue: formPro.emission,
              title: 'emission_standards'.tr(),
              onChanged: (String? value) => formPro.setemissionType(value),
            ),

            /// Make dynamic dropdown
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: make,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'make'.tr(),
              // categoryKey: 'make',
              selectedValue: formPro.make,
              title: 'make'.tr(),
              onChanged: (String? value) => formPro.seteMake(value),
            ),

            /// Fuel type dynamic dropdown
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: fuelType,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'fuel_type'.tr(),
              // categoryKey: 'fuel_type',
              selectedValue: formPro.fuelTYpe,
              title: 'fuel_type'.tr(),
              onChanged: (String? value) => formPro.setFuelType(value),
            ),

            /// Transmission dynamic dropdown
            CustomListingDropDown<AddListingFormProvider, DropdownOptionEntity>(
              options: transmission,
              valueGetter: (DropdownOptionEntity opt) => opt.value.value,
              labelGetter: (DropdownOptionEntity opt) => opt.label,
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'transmission'.tr(),
              // categoryKey: 'transmission',
              selectedValue: formPro.transmissionType,
              title: 'transmission'.tr(),
              onChanged: (String? value) =>
                  formPro.setTransmissionType(value ?? ''),
            ),

            /// Color dropdown
            ColorDropdown(
              validator: (bool? value) => AppValidator.requireSelection(value),
              title: 'color'.tr(),
              selectedColor: formPro.selectedVehicleColor,
              onColorChanged: (ColorOptionEntity? value) =>
                  formPro.setVehicleColor(value),
            ),

            /// Location field
            NominationLocationField(
              validator: (bool? value) => AppValidator.requireLocation(value),
              title: 'meetup_location'.tr(),
              selectedLatLng: formPro.collectionLatLng,
              displayMode: MapDisplayMode.showMapAfterSelection,
              initialText: formPro.selectedmeetupLocation?.address ?? '',
              onLocationSelected: (LocationEntity p0, LatLng p1) =>
                  formPro.setMeetupLocation(p0, p1),
            ),

            /// Price
            CustomTextFormField(
              controller: formPro.price,
              labelText: 'price'.tr(),
              hint: 'Ex. 12000.0',
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              prefixText: LocalAuth.currency.toUpperCase(),
              keyboardType: TextInputType.number,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),

            /// Model
            CustomTextFormField(
              controller: formPro.model,
              labelText: 'model'.tr(),
              hint: 'model'.tr(),
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              keyboardType: TextInputType.text,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
