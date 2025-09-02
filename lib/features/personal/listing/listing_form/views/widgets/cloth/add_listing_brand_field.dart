import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingBrandField extends StatelessWidget {
  const AddListingBrandField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    return CustomTextFormField(
        hint: 'type_here'.tr(),
        labelText: 'brand'.tr(),
        controller: formPro.brand);
  }
}
