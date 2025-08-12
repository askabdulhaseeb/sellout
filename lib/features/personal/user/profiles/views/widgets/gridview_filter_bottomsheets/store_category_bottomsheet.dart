import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../providers/profile_provider.dart';

class StoreCategoryBottomSheet extends StatelessWidget {
  const StoreCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final ListingType? selectedCategory = profileProvider.category;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        backgroundBlendMode: BlendMode.color,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BackButton(
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'choose_category'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    profileProvider.resetStoreCategoryButton();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'reset'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.primaryColor,
                        color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ...ListingType.storeList.map((ListingType type) {
            final bool isSelected = selectedCategory == type;
            return ListTile(
              leading: _buildLeadingIcon(context, isSelected),
              title: Text(type.code.tr()),
              onTap: () {
                profileProvider.setCategory(type);
                Navigator.pop(context); // Close bottom sheet
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
              ? AppTheme.primaryColor
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: AppTheme.primaryColor, size: 18)
          : null,
    );
  }
}
