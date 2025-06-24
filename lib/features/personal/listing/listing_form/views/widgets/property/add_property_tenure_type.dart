import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/add_listing_form_provider.dart';

enum TenureType {
  freehold,
  leasehold,
}

extension TenureTypeExtension on TenureType {
  String get value {
    switch (this) {
      case TenureType.freehold:
        return 'freehold';
      case TenureType.leasehold:
        return 'leasehold';
    }
  }

  String get localized => value.tr();
}

class AddListingTenureTypeSelection extends StatelessWidget {
  const AddListingTenureTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<TenureType> tenureTypes = TenureType.values;

    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider addPro, _) {
        final List<String> stringValues =
            tenureTypes.map((e) => e.value).toList();
        final List<String> localizedValues =
            tenureTypes.map((e) => e.localized).toList();

        return CustomToggleSwitch<String>(
          isShaded: false,
          labels: stringValues,
          labelStrs: localizedValues,
          labelText: 'tenure_type'.tr(),
          initialValue: addPro.tenureType,
          onToggle: addPro.setSelectedTenureType,
        );
      },
    );
  }
}
