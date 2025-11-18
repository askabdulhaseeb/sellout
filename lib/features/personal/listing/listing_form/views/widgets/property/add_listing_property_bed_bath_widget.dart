import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';

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
          spacing: AppSpacing.vSm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              spacing: AppSpacing.hSm,
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

            // Price
            CustomTextFormField(
              controller: formPro.price,
              validator: (String? value) => AppValidator.isEmpty(value),
              labelText: 'price'.tr(),
              hint: 'Ex. 350',
              keyboardType: TextInputType.number,
            ),

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
              selectedItem: formPro.findByValue(
                  propertyTypes, formPro.selectedPropertyType ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'select_category'.tr(),
              onChanged: (DropdownOptionEntity? opt) =>
                  formPro.setPropertyType(opt?.value.value),
              title: 'category'.tr(),
            ),
            // Energy Rating Dropdown
            CustomDropdown<DropdownOptionDataEntity>(
              // Build dropdown items
              items: energyRatings.map(
                (DropdownOptionDataEntity e) {
                  return DropdownMenuItem<DropdownOptionDataEntity>(
                    value: e,
                    child: Text(e.label),
                  );
                },
              ).toList(),
              selectedItem: DropdownOptionDataEntity.findByValue(
                  energyRatings, formPro.selectedEnergyRating ?? ''),
              validator: (bool? value) => AppValidator.requireSelection(value),
              hint: 'energy_rating'.tr(),
              title: 'energy_rating'.tr(),

              // When user changes selection
              onChanged: (DropdownOptionDataEntity? value) {
                formPro.setEnergyRating(value?.value);
              },
            ),
          ],
        );
      },
    );
  }
}
