import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: CustomTextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            labelText: isKg ? tr('weight_kg') : tr('weight_lb'),
          ),
        ),
        const SizedBox(width: 8),
        Row(
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
      ],
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: scheme.outline),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: selected ? scheme.primary : null,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
