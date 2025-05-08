import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingTenureTypeSelection extends StatelessWidget {
  const AddListingTenureTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tenureTypes = <String>['freehold', 'leasehold'];

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider addPro, _) {
        return CustomToggleSwitch<String>(
          labels: tenureTypes,
          labelStrs: tenureTypes.map((String e) => e.tr()).toList(),
          labelText: 'tenure_type'.tr(),
          initialValue: addPro.tenureType,
          onToggle: addPro.setSelectedTenureType,
        );
      },
    );
  }
}
