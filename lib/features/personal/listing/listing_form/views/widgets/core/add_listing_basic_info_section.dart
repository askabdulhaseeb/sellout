import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';
import '../attachment_selection/add_listing_attachment_selection_widget.dart';

class AddListingBasicInfoSection extends StatelessWidget {
  const AddListingBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Column(
          children: <Widget>[
            CustomTextFormField(
              controller: formPro.title,
              labelText: 'What are you selling?',
              hint: 'Enter product name',
              autoFocus: true,
              showSuffixIcon: true,
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
            const SizedBox(height: 16),
            const AddListingAttachmentSelectionWidget(),
            CustomTextFormField(
              controller: formPro.description,
              hint: 'Enter product Description...',
              isExpanded: true,
              maxLines: 5,
              showSuffixIcon: false,
              labelText: 'Describe your product',
              validator: (String? value) => AppValidator.isEmpty(value),
            ),
          ],
        );
      },
    );
  }
}
