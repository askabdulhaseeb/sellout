import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';

class StoreCategoryBottomSheet extends StatelessWidget {
  const StoreCategoryBottomSheet({
    required this.selectedCategory,
    required this.categoryOptions,
    required this.onReset,
    required this.onSelect,
    super.key,
  });

  final ListingType? selectedCategory;
  final List<ListingType> categoryOptions;
  final VoidCallback onReset;
  final ValueChanged<ListingType> onSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Theme.of(context).scaffoldBackgroundColor,
        backgroundBlendMode: BlendMode.color,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackButton(onPressed: () => Navigator.pop(context)),
              Text(
                'choose_category'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  onReset();
                  Navigator.pop(context);
                },
                child: Text(
                  'reset'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          ...categoryOptions.map((ListingType type) {
            final bool isSelected = selectedCategory == type;
            return ListTile(
              leading: _buildLeadingIcon(context, isSelected),
              title: Text(type.code.tr()),
              onTap: () {
                onSelect(type);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
      ),
      child: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor, size: 18)
          : null,
    );
  }
}
