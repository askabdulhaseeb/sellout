import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../core/widgets/custom_textformfield.dart';

class WeightSection extends StatelessWidget {
  const WeightSection({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    String? weightValidator(String? value) {
      final String input = (value ?? '').trim();
      if (input.isEmpty) return AppValidator.isEmpty(input);

      final double? v = double.tryParse(input.replaceAll(',', '.'));
      if (v == null || v <= 0) return 'invalid_value'.tr();

      return null;
    }

    final double incomingKg =
        double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;

    // Print incoming KG value
    print("📥 Incoming raw KG value: $incomingKg");

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
              onChanged: (v) {
                final double newKg =
                    double.tryParse(v.replaceAll(',', '.')) ?? 0;

                print("✏️ User typed → raw KG stored = $newKg");
              },
            ),
          ),
        ),
      ],
    );
  }
}
