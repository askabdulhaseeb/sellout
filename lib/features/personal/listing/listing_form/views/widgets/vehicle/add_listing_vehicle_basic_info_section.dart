import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dropdowns/color_dropdown.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../marketplace/views/widgets/market_categorized_filters_page_widgets/widgets/vehicle_filter/widget/year_picker_dropdown.dart';
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
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Year
            CustomYearDropdown(
              hintText: 'year'.tr(),
              title: 'year'.tr(),
              selectedYear: formPro.year,
              onChanged: (String? value) => formPro.setYear(value),
            ),

            /// Body type dynamic dropdown *second part of address
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'body_type'.tr(),
              parentValue: formPro.selectedVehicleCategory,
              categoryKey: 'body_type',
              selectedValue: formPro.selectedBodyType,
              title: 'body_type'.tr(),
              onChanged: (String? value) => formPro.setBodyType(value ?? ''),
            ),

            /// Emission standard dynamic dropdown
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'emission_standards'.tr(),
              categoryKey: 'emission_standards',
              selectedValue: formPro.emission,
              title: 'emission_standards'.tr(),
              onChanged: (String? value) => formPro.setemissionType(value),
            ),

            /// Make dynamic dropdown
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'make'.tr(),
              categoryKey: 'make',
              selectedValue: formPro.make,
              title: 'make'.tr(),
              onChanged: (String? value) => formPro.seteMake(value),
            ),

            /// Fuel type dynamic dropdown
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'fuel_type'.tr(),
              categoryKey: 'fuel_type',
              selectedValue: formPro.fuelTYpe,
              title: 'fuel_type'.tr(),
              onChanged: (String? value) => formPro.setFuelType(value),
            ),

            /// Transmission dynamic dropdown
            CustomListingDropDown<AddListingFormProvider>(
              validator: (bool? p0) => null,
              hint: 'transmission'.tr(),
              categoryKey: 'transmission',
              selectedValue: formPro.transmissionType,
              title: 'transmission'.tr(),
              onChanged: (String? value) =>
                  formPro.setTransmissionType(value ?? ''),
            ),

            ColorDropdown(
              validator: (bool? p0) => null,
              title: 'color'.tr(),
              selectedColor: formPro.selectedVehicleColor,
              onColorChanged: (ColorOptionEntity? value) =>
                  formPro.setVehicleColor(value),
            ),
            //price
            CustomTextFormField(
                controller: formPro.price,
                labelText: 'price'.tr(),
                hint: 'Ex. 12000.0',
                showSuffixIcon: false,
                readOnly: formPro.isLoading,
                prefixText: LocalAuth.currency.toUpperCase(),
                keyboardType: TextInputType.number,
                validator: (String? value) => AppValidator.isEmpty(value)),
            //model
            CustomTextFormField(
              controller: formPro.model,
              labelText: 'model'.tr(),
              hint: 'Ex. Toyota Camry or Corolla',
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              keyboardType: TextInputType.text,
              validator: AppValidator.isEmpty,
            ),
          ],
        );
      },
    );
  }
}
