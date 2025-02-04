import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingPostButtonWidget extends StatelessWidget {
  const AddListingPostButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
        builder: (BuildContext context, AddListingFormProvider formPro, _) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'please_note_that_delivery_must_be_tracked'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          CustomElevatedButton(
            title: 'post'.tr(),
            isLoading: formPro.isLoading,
            onTap: () async => await formPro.submit(context),
          ),
          const SizedBox(height: 240),
        ],
      );
    });
  }
}
