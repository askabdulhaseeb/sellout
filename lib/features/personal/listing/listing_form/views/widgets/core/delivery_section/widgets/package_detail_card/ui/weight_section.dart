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
              labelText: isKg ? tr('weight_kg') : tr('weight_lb'),
              validator: weightValidator,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _UnitChip(
                label: 'kg',
                selected: isKg,
                onTap: () => onToggleUnit(true),
              ),
              const SizedBox(width: 6),
              _UnitChip(
                label: 'lb',
                selected: !isKg,
                onTap: () => onToggleUnit(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
