import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
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
          InDevMode(
            child: CustomElevatedButton(
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
                textColor: Theme.of(context).colorScheme.secondary,
                bgColor: Colors.transparent,
                title: 'promotion_boost'.tr(),
                isLoading: false,
                onTap: () {}),
          ),
          // --- PREVIEW BUTTON ---
          CustomElevatedButton(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            textColor: Theme.of(context).colorScheme.outline,
            bgColor: Colors.transparent,
            title: 'preview_listing'.tr(),
            isLoading: formPro.isLoading,
            onTap: () async => await formPro.getPreview(context),
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
