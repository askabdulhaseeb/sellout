import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';

// Moved to ui/size_category_tile.dart
class SizeCategoryTile extends StatelessWidget {
  const SizeCategoryTile({
    required this.label,
    required this.presets,
    required this.isSelectedDims,
    required this.onSelectDims,
    super.key,
  });

  final String label;
  final List<Map<String, dynamic>> presets;
  final bool Function(List<dynamic> dims) isSelectedDims;
  final void Function(List<dynamic> dims) onSelectDims;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      children: <Widget>[
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: presets.map((Map<String, dynamic> preset) {
            final List<dynamic> dims = preset['dims'];
            final bool selected = isSelectedDims(dims);
            return SizedBox(
              height: 34,
              child: CustomElevatedButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 0,
                ),
                margin: EdgeInsets.zero,
                isLoading: false,
                bgColor: selected
                    ? scheme.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                border: Border.all(color: scheme.outline),
                title: '${preset["label"]} (${dims.join("×")} ${tr("cm")})',
                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: scheme.onSurface,
                ),
                onTap: () => onSelectDims(dims),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
