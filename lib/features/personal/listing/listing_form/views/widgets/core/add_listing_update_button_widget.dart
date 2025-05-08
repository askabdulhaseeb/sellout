import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingUpdateButtons extends StatelessWidget {
  const AddListingUpdateButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    return Row(
      spacing: 6,
      children: <Widget>[
        Expanded(
          child: CustomElevatedButton(
              bgColor: ColorScheme.of(context).surface,
              border: Border.all(color: ColorScheme.of(context).onSurface),
              title: 'delete'.tr(),
              textColor: ColorScheme.of(context).onSurface,
              isLoading: formPro.isLoading,
              onTap: () {}),
        ),
        Expanded(
          child: CustomElevatedButton(
            title: 'update'.tr(),
            isLoading: formPro.isLoading,
            onTap: () {
              formPro.submit(context);
            },
          ),
        ),
      ],
    );
  }
}
