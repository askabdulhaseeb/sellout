import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';
import '../custom_listing_dropdown.dart';

class AddListingVehicleTernsmissionEngineMileageSection
    extends StatelessWidget {
  const AddListingVehicleTernsmissionEngineMileageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
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
                  child: CustomListingDropDown<AddListingFormProvider>(
                    hint: 'mileage_unit'.tr(),
                    categoryKey: 'mileage_unit',
                    selectedValue: formPro.selectedMileageUnit,
                    title: 'mileage_unit'.tr(),
                    onChanged: formPro.setMileageUnit,
                    validator: (bool? value) =>
                        AppValidator.requireSelection(value),
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
