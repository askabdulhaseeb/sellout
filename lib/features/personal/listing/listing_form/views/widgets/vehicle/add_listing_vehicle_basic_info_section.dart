import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingVehicleBasicInfoSection extends StatelessWidget {
  const AddListingVehicleBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider formPro, _) {
      // final List<int> years =
      //     List<int>.generate(80, (int index) => DateTime.now().year - index);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextFormField(
            controller: formPro.price,
            labelText: 'price'.tr(),
            hint: 'Ex. 12000.0',
            showSuffixIcon: false,
            readOnly: formPro.isLoading,
            prefixText: LocalAuth.currency.toUpperCase(),
            keyboardType: TextInputType.number,
            validator: (String? value) => AppValidator.isEmpty(value),
          ), 
        ],
      );
    });
  }
}
