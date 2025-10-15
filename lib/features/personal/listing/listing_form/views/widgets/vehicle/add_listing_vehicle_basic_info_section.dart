import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/dropdowns/color_dropdown.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../location/domain/enums/map_display_mode.dart';
import '../../../../../location/view/widgets/location_field.dart/nomination_location_field.dart';
import '../../../../../marketplace/views/widgets/market_categorized_filters_page_widgets/widgets/vehicle_filter/widget/year_picker_dropdown.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/category_entites/subentities/parent_dropdown_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../providers/add_listing_form_provider.dart';

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
    final List<ParentDropdownEntity> bodyType =
        LocalCategoriesSource.bodyType ?? <ParentDropdownEntity>[];
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
          spacing: AppSpacing.vXs,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Category
            CustomDropdown<DropdownOptionEntity>(
              items: vehiclecatgory.map((DropdownOptionEntity opt) {
                return DropdownMenuItem<DropdownOptionEntity>(
                  value: opt,
                  child: Text(opt.label),
                );
              }).toList(),
              selectedItem: DropdownOptionEntity.findByValue(
                  vehiclecatgory, formPro.selectedVehicleCategory ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'select_category'.tr(),
              title: 'category'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setVehicleCategory(value?.value.value),
            ),

            /// Year
            CustomYearDropdown(
              hintText: 'year'.tr(),
              title: 'year'.tr(),
              selectedYear: formPro.year,
              onChanged: (String? value) => formPro.setYear(value),
              validator: (bool? value) => AppValidator.requireSelection(value),
            ),

            AddListingBodyTypeWidget(list: bodyType),
            // 🔹 Emission standard
            CustomDropdown<DropdownOptionEntity>(
              items: emissionStandards
                  .map((DropdownOptionEntity e) =>
                      DropdownMenuItem<DropdownOptionEntity>(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              selectedItem: DropdownOptionEntity.findByValue(
                  emissionStandards, formPro.emission ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'emission_standards'.tr(),
              title: 'emission_standards'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setEmissionType(value?.value.value),
            ),

            // 🔹 Make
            CustomDropdown<DropdownOptionEntity>(
              items: make
                  .map((DropdownOptionEntity e) =>
                      DropdownMenuItem<DropdownOptionEntity>(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              selectedItem:
                  DropdownOptionEntity.findByValue(make, formPro.make ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'make'.tr(),
              title: 'make'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setMake(value?.value.value),
            ),

            // 🔹 Fuel type
            CustomDropdown<DropdownOptionEntity>(
              items: fuelType
                  .map((DropdownOptionEntity e) =>
                      DropdownMenuItem<DropdownOptionEntity>(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              selectedItem: DropdownOptionEntity.findByValue(
                  fuelType, formPro.fuelType ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'fuel_type'.tr(),
              title: 'fuel_type'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setFuelType(value?.value.value),
            ),

            // 🔹 Transmission
            CustomDropdown<DropdownOptionEntity>(
              items: transmission
                  .map((DropdownOptionEntity e) =>
                      DropdownMenuItem<DropdownOptionEntity>(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              selectedItem: DropdownOptionEntity.findByValue(
                  transmission, formPro.transmissionType ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'transmission'.tr(),
              title: 'transmission'.tr(),
              onChanged: (DropdownOptionEntity? value) =>
                  formPro.setTransmissionType(value?.value.value ?? ''),
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
              initialText: formPro.selectedMeetupLocation?.address ?? '',
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

class AddListingBodyTypeWidget extends StatelessWidget {
  const AddListingBodyTypeWidget({
    required this.list,
    super.key,
  });

  final List<ParentDropdownEntity> list;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        // Find matches safely
        final Iterable<ParentDropdownEntity> matches = list.where(
          (ParentDropdownEntity p) =>
              p.category == formPro.selectedVehicleCategory,
        );

        // Get the first match or null
        final ParentDropdownEntity? match =
            matches.isNotEmpty ? matches.first : null;

        // Options are empty if no match
        final List<DropdownOptionEntity> options =
            match?.options ?? <DropdownOptionEntity>[];

        return CustomDropdown<DropdownOptionEntity>(
          items: options
              .map(
                (DropdownOptionEntity opt) =>
                    DropdownMenuItem<DropdownOptionEntity>(
                  value: opt,
                  child: Text(opt.label),
                ),
              )
              .toList(),

          // selectedItem safe
          selectedItem: ParentDropdownEntity.getOptionByValue(
            formPro.selectedBodyType ?? '',
            options,
          ),

          validator: (bool? value) => AppValidator.requireSelection(value),
          hint: 'body_type'.tr(),
          title: 'body_type'.tr(),

          // onChanged safe
          onChanged: (DropdownOptionEntity? value) =>
              formPro.setBodyType(value?.value.value ?? ''),
        );
      },
    );
  }
}
