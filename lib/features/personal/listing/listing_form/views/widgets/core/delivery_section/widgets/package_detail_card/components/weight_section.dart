import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../../core/widgets/inputs/custom_textformfield.dart';

// Moved to ui/weight_section.dart
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
      // Enforce only when parcel details are required
      // Access via an inherited widget would be ideal, but this stays UI-only
      final String input = (value ?? '').trim();
      // If delivery type is collection, skip
      // We can’t access provider here without importing it; keep a lenient check and let form-level validation handle other cases
      if (input.isEmpty) return AppValidator.isEmpty(input);
      final double? v = double.tryParse(input.replaceAll(',', '.'));
      if (v == null || v <= 0) return 'invalid_value'.tr();
      return null;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Use Flexible instead of Expanded to prevent layout stretch
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
        // Wrap the chips in a Center to align vertically
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.hSm,
          vertical: AppSpacing.vXs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
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
