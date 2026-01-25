import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../providers/add_listing_form_provider.dart';
import '../../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../core/enums/listing/core/delivery_type.dart';

class InlineSizeField extends StatelessWidget {
  const InlineSizeField({
    required this.labelKey,
    required this.controller,
    required this.formPro,
    super.key,
  });

  final String labelKey;
  final TextEditingController controller;
  final AddListingFormProvider formPro;

  @override
  Widget build(BuildContext context) {
    String? validator(String? value) {
      if (formPro.deliveryType != DeliveryType.paid &&
          formPro.deliveryType != DeliveryType.freeDelivery) {
        return null;
      }
      final String input = (value ?? '').trim();
      if (input.isEmpty) return AppValidator.isEmpty(input);
      final double? v = double.tryParse(input.replaceAll(',', '.'));
      if (v == null || v <= 0) return 'invalid_value'.tr();
      return null;
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        labelText: tr(labelKey),
        suffixText: tr('cm'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.vSm,
        ),
      ),
    );
  }
}
