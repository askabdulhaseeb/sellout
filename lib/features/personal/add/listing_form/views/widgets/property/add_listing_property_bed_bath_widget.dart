import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingPropertyBedBathWidget extends StatelessWidget {
  const AddListingPropertyBedBathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider formPro, _) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                controller: formPro.bedroom,
                labelText: 'Bedroom',
                hint: 'Ex. 4',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextFormField(
                controller: formPro.bathroom,
                labelText: 'Bathroom',
                hint: 'Ex. 3',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        );
      },
    );
  }
}
