import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dialogs/cart/dropdowns/color_dropdown.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
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
            /// Price
            CustomTextFormField(
              controller: formPro.price,
              labelText: 'price'.tr(),
              hint: 'Ex. 12000.0',
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              prefixText: LocalAuth.currency.toUpperCase(),
              keyboardType: TextInputType.number,
              validator: AppValidator.isEmpty,
            ),

            /// Year
            CustomTextFormField(
              controller: formPro.year,
              labelText: 'year'.tr(),
              hint: 'Ex. 2025',
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              keyboardType: TextInputType.number,
              validator: AppValidator.isEmpty,
            ),

            /// Body type dynamic dropdown
            CustomListingDropDown(
              categoryKey: 'body_type',
              selectedValue: formPro.selectedBodyType,
              title: 'body_type',
              onChanged: (String? value) => formPro.setBodyType(value ?? ''),
            ),

            /// Emission standard dynamic dropdown
            CustomListingDropDown(
              categoryKey: 'emission_standards',
              selectedValue: formPro.emission,
              title: 'emission_standards',
              onChanged: (String? value) => formPro.setemissionType(value),
            ),

            /// Make dynamic dropdown
            CustomListingDropDown(
              categoryKey: 'make',
              selectedValue: formPro.make,
              title: 'make'.tr(),
              onChanged: (String? value) => formPro.seteMake(value),
            ),

            /// Model
            CustomTextFormField(
              controller: formPro.model,
              labelText: 'model'.tr(),
              hint: 'Ex. Toyota Camry or Corolla',
              showSuffixIcon: false,
              readOnly: formPro.isLoading,
              keyboardType: TextInputType.text,
              validator: AppValidator.isEmpty,
            ),

            /// Fuel type dynamic dropdown
            CustomListingDropDown(
              categoryKey: 'fuel_type',
              selectedValue: formPro.fuelTYpe,
              title: 'fuel_type',
              onChanged: (String? value) => formPro.setFuelType(value),
            ),

            /// Transmission dynamic dropdown
            CustomListingDropDown(
              categoryKey: 'transmission',
              selectedValue: formPro.transmissionType,
              title: 'transmission'.tr(),
              onChanged: (String? value) =>
                  formPro.setTransmissionType(value ?? ''),
            ),
            ColorDropdown(
              selectedColor: formPro.selectedVehicleColor,
              onColorChanged: (String? value) =>
                  formPro.setVehicleColor(value ?? ''),
            )

            /// Color with color dots
            //   FutureBuilder<List<ColorOptionEntity>>(
            //     future: formPro.(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<ColorOptionEntity>> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       final List<ColorOptionEntity> colorOptionsList =
            //           snapshot.data ?? [];

            //       return CustomDropdown<String>(
            //         isSearchable: true,
            //         padding: const EdgeInsets.symmetric(vertical: 4),
            //         hint: 'color'.tr(),
            //         selectedItem: formPro.selectedVehicleColor,
            //         title: 'color'.tr(),
            //         validator: (_) => null,
            //         items: colorOptionsList.map((ColorOptionEntity color) {
            //           return DropdownMenuItem<String>(
            //             value: color.value,
            //             child: Row(
            //               children: <Widget>[
            //                 CircleAvatar(
            //                   radius: 10,
            //                   backgroundColor: Color(
            //                     int.parse(
            //                         '0xFF${color.value.replaceAll('#', '')}'),
            //                   ),
            //                 ),
            //                 const SizedBox(width: 8),
            //                 Expanded(child: Text(color.label)),
            //               ],
            //             ),
            //           );
            //         }).toList(),
            //         onChanged: (String? newValue) =>
            //             formPro.setVehicleColor(newValue ?? ''),
            //       );
            //     },
            //   ),
          ],
        );
      },
    );
  }
}
