import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';
import '../location_by_name_field.dart';
import 'energyrating_dropdown.dart';
import 'property_type_dropdown.dart';

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
            const EnergyRatingDropdown(),
            const PropertyTypeDropdown(),
            const LocationInputField(),
          ],
        );
      },
    );
  }
}
