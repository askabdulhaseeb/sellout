import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingVehicleTransmissionEngineMileageSection
    extends StatelessWidget {
  const AddListingVehicleTransmissionEngineMileageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DropdownOptionEntity> mileageUnit =
        LocalCategoriesSource.mileageUnit ?? <DropdownOptionEntity>[];
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          spacing: AppSpacing.vSm,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormField(
              validator: (String? value) => AppValidator.isEmpty(value),
              controller: formPro.engineSize,
              labelText: 'Engine Size',
              hint: 'Ex. 1.6',
              keyboardType: TextInputType.number,
            ),
            Row(
              spacing: 4,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: CustomTextFormField(
                    controller: formPro.mileage,
                    labelText: 'mileage'.tr(),
                    hint: 'Ex. 10000',
                    keyboardType: TextInputType.number,
                    validator: (String? value) => AppValidator.isEmpty(value),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomDropdown<DropdownOptionEntity>(
                    items: mileageUnit.map((opt) {
                      return DropdownMenuItem<DropdownOptionEntity>(
                        value: opt,
                        child: Text(opt.label), // display label
                      );
                    }).toList(),
                    selectedItem: formPro.findByValue(
                        mileageUnit, formPro.selectedMileageUnit ?? ''),
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
                    hint: 'mileage_unit'.tr(),
                    title: 'mileage_unit'.tr(),
                    onChanged: (DropdownOptionEntity? value) =>
                        formPro.setMileageUnit(value?.value.value),
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              controller: formPro.doors,
              labelText: 'doors'.tr(),
              hint: 'Ex. 4',
              keyboardType: TextInputType.number,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
            CustomTextFormField(
              controller: formPro.seats,
              labelText: 'seats'.tr(),
              hint: 'Ex. 5',
              keyboardType: TextInputType.number,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
