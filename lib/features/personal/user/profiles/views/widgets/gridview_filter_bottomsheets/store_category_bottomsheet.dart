import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../providers/profile_store_posts_provider.dart';
import '../../providers/profile_viewing_posts_provider.dart';

class StoreCategoryBottomSheet extends StatelessWidget {
  const StoreCategoryBottomSheet({required this.isStore, super.key});
  final bool isStore;
  @override
  Widget build(BuildContext context) {
    final ListingType? selectedCategory = isStore
        ? context.watch<ProfileStorePostsProvider>().category
        : context.watch<ProfileViewingPostsProvider>().category;
    final List<ListingType> categoryOptions = isStore
        ? ListingType.storeList
        : ListingType.viewingList;
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
                  if (isStore) {
                    context.read<ProfileStorePostsProvider>().resetCategory();
                  } else {
                    context.read<ProfileViewingPostsProvider>().resetCategory();
                  }
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
                if (isStore) {
                  context.read<ProfileStorePostsProvider>().setCategory(type);
                } else {
                  context.read<ProfileViewingPostsProvider>().setCategory(type);
                }
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
