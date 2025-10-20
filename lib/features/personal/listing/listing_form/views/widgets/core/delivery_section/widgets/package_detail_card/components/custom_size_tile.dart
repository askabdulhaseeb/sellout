import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../providers/add_listing_form_provider.dart';

class CustomSizeTile extends StatelessWidget {
  const CustomSizeTile({required this.formPro, super.key});

  final AddListingFormProvider formPro;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        tr('custom_size'),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: _PackageInputField(
                labelKey: 'length',
                controller: formPro.packageLength,
              ),
            ),
            const SizedBox(width: AppSpacing.hXs),
            Flexible(
              flex: 1,
              child: _PackageInputField(
                labelKey: 'width',
                controller: formPro.packageWidth,
              ),
            ),
            const SizedBox(width: AppSpacing.hXs),
            Flexible(
              flex: 1,
              child: _PackageInputField(
                labelKey: 'height',
                controller: formPro.packageHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.vSm),
      ],
    );
  }
}

class _PackageInputField extends StatelessWidget {
  const _PackageInputField({required this.labelKey, required this.controller});

  final String labelKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      suffixIcon: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('cm')],
      ),
      controller: controller,
      keyboardType: TextInputType.number,
      labelText: tr(labelKey),
      validator: (String? value) => AppValidator.isEmpty(value),
    );
  }
}
