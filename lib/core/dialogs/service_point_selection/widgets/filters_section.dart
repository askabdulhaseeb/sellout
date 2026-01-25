import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_spacings.dart';
import '../enums/service_point_enums.dart';

class FiltersSection extends StatelessWidget {
  const FiltersSection({
    required this.selectedRadius,
    required this.selectedCategory,
    required this.onRadiusChanged,
    required this.onCategoryChanged,
    this.productName,
    super.key,
  });

  final SearchRadius selectedRadius;
  final ServicePointCategory selectedCategory;
  final Function(SearchRadius) onRadiusChanged;
  final Function(ServicePointCategory) onCategoryChanged;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (productName != null) ...<Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.inventory_2_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${'applying_to'.tr()}: $productName',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text('search_radius'.tr(), style: textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SearchRadius.values
                  .map(
                    (SearchRadius radius) => _RadiusChip(
                      radius: radius,
                      isSelected: selectedRadius == radius,
                      onSelected: onRadiusChanged,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('category'.tr(), style: textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ServicePointCategory.values
                  .map(
                    (ServicePointCategory category) => _CategoryChip(
                      category: category,
                      isSelected: selectedCategory == category,
                      onSelected: onCategoryChanged,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.radius,
    required this.isSelected,
    required this.onSelected,
  });

  final SearchRadius radius;
  final bool isSelected;
  final Function(SearchRadius) onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      showCheckmark: false,
      label: Text(radius.label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) onSelected(radius);
      },
      selectedColor: colorScheme.primary.withValues(alpha: 0.1),
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outline,
        width: 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  final ServicePointCategory category;
  final bool isSelected;
  final Function(ServicePointCategory) onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(category.key.tr()),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) onSelected(category);
      },
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outline,
        width: 1,
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
    );
  }
}
