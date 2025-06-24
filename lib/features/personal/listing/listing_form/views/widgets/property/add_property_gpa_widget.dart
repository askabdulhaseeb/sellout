import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';
import 'add_property_tenure_type.dart';

class AddPropertyGPAWidget extends StatelessWidget {
  const AddPropertyGPAWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomToggleSwitch<bool>(
              isShaded: false,
              labels: const <bool>[true, false],
              labelStrs: <String>['yes'.tr(), 'no'.tr()],
              labelText: 'garden'.tr(),
              initialValue: formPro.garden,
              onToggle: formPro.setGarden,
            ),
            CustomToggleSwitch<bool>(
              isShaded: false,
              labels: const <bool>[true, false],
              labelStrs: <String>['yes'.tr(), 'no'.tr()],
              labelText: 'parking'.tr(),
              initialValue: formPro.parking,
              onToggle: formPro.setParking,
            ),
            CustomToggleSwitch<bool>(
              isShaded: false,
              labels: const <bool>[true, false],
              labelStrs: <String>['yes'.tr(), 'no'.tr()],
              labelText: 'animal_friendly'.tr(),
              initialValue: formPro.animalFriendly,
              onToggle: formPro.setAnimalFriendly,
            ),
            const AddListingTenureTypeSelection(),
          ],
        );
      },
    );
  }
}
