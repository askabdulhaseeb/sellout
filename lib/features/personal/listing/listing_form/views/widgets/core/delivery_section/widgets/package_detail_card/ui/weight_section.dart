import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../core/widgets/custom_textformfield.dart';

class WeightSection extends StatelessWidget {
  const WeightSection({
    required this.controller,
    required this.isKg,
    required this.onToggleUnit,
    super.key,
  });

  final TextEditingController controller;
  final bool isKg;
  final void Function(bool toKg) onToggleUnit;

  @override
  Widget build(BuildContext context) {
    String? weightValidator(String? value) {
      final String input = (value ?? '').trim();
      if (input.isEmpty) return AppValidator.isEmpty(input);
      final double? v = double.tryParse(input.replaceAll(',', '.'));
      if (v == null || v <= 0) return 'invalid_value'.tr();
      return null;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Align(
            alignment: Alignment.center,
            child: CustomTextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              labelText: tr('weight_kg'),
              validator: weightValidator,
            ),
          ),
        ),
      ],
    );
  }
}
