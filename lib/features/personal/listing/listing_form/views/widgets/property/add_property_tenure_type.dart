import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/property/tenure_type.dart';
import '../../../../../../../core/widgets/toggles/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingTenureTypeSelection extends StatelessWidget {
  const AddListingTenureTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<TenureType> tenureTypes = TenureType.values;

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider addPro, _) {
        final List<String> localizedValues = tenureTypes
            .map((TenureType e) => e.localized)
            .toList();
        return CustomToggleSwitch<TenureType>(
          verticalPadding: 8,
          containerHeight: 48,
          isShaded: false,
          labels: tenureTypes,
          labelStrs: localizedValues,
          labelText: 'tenure_type'.tr(),
          initialValue: addPro.tenureType,
          onToggle: addPro.setSelectedTenureType,
        );
      },
    );
  }
}
