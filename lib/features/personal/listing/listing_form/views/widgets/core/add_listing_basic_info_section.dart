import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';
import '../attachment_selection/add_listing_attachment_selection_widget.dart';

class AddListingBasicInfoSection extends StatelessWidget {
  const AddListingBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          spacing: AppSpacing.vXs,
          children: <Widget>[
            CustomTextFormField(
              controller: formPro.title,
              labelText: 'what_are_you_selling'.tr(),
              hint: 'enter_product_name'.tr(),
              showSuffixIcon: true,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
            const AddListingAttachmentSelectionWidget(),
            CustomTextFormField(
              contentPadding: const EdgeInsets.all(6),
              controller: formPro.description,
              hint: 'enter_product_description'.tr(),
              isExpanded: true,
              maxLines: 5,
              labelText: 'describe_product'.tr(),
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
