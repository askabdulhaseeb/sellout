import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../data/models/user_model.dart';
import '../enums/profile_page_tab_type.dart';
import '../providers/profile_store_posts_provider.dart';
import '../providers/profile_viewing_posts_provider.dart';
import 'gridview_filter_bottomsheets/store_category_bottomsheet.dart';
import 'gridview_filter_bottomsheets/store_filter_bottomsheet.dart';
import 'dart:async';

class ProfileFilterSection extends StatelessWidget {
  const ProfileFilterSection({
    required this.user,
    required this.pageType,
    super.key,
  });
  final UserEntity? user;
  final ProfilePageTabType? pageType;

  @override
  Widget build(BuildContext context) {
    final bool isStore = (pageType!.code == ProfilePageTabType.store.code);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 4,
        children: <Widget>[
          Flexible(child: ProfilePostSearchField(isStore: isStore)),
          Expanded(
            child: CustomFilterButton(
              iconFirst: false,
              onPressed: () {
                if (isStore) {
                  final ProfileStorePostsProvider provider = context
                      .read<ProfileStorePostsProvider>();
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => StoreCategoryBottomSheet(
                      selectedCategory: provider.category,
                      categoryOptions: ListingType.storeList,
                      onReset: provider.resetCategory,
                      onSelect: provider.setCategory,
                    ),
                  );
                  return;
                }

                final ProfileViewingPostsProvider provider = context
                    .read<ProfileViewingPostsProvider>();
                showModalBottomSheet(
                  context: context,
                  builder: (_) => StoreCategoryBottomSheet(
                    selectedCategory: provider.category,
                    categoryOptions: ListingType.viewingList,
                    onReset: provider.resetCategory,
                    onSelect: provider.setCategory,
                  ),
                );
              },
              label: 'category'.tr(),
              icon: AppStrings.selloutDropDownIcon,
            ),
          ),
          Expanded(
            child: CustomFilterButton(
              iconFirst: true,
              onPressed: () {
                if (isStore) {
                  final ProfileStorePostsProvider provider = context
                      .read<ProfileStorePostsProvider>();
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: false,
                    isDismissible: false,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (_) => StoreFilterBottomSheet(
                      sort: provider.sort,
                      onSortChanged: provider.setSort,
                      minPriceController: provider.minPriceController,
                      maxPriceController: provider.maxPriceController,
                      showStoreFields: true,
                      selectedConditionType: provider.selectedConditionType,
                      onConditionChanged: provider.setConditionType,
                      selectedDeliveryType: provider.selectedDeliveryType,
                      onDeliveryTypeChanged: provider.setDeliveryType,
                      onReset: provider.filterSheetReset,
                      onApply: provider.filterSheetApply,
                      isLoading: provider.isLoading,
                    ),
                  );
                  return;
                }

                final ProfileViewingPostsProvider provider = context
                    .read<ProfileViewingPostsProvider>();
                showModalBottomSheet(
                  context: context,
                  showDragHandle: false,
                  isDismissible: false,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (_) => StoreFilterBottomSheet(
                    sort: provider.sort,
                    onSortChanged: provider.setSort,
                    minPriceController: provider.minPriceController,
                    maxPriceController: provider.maxPriceController,
                    onReset: provider.filterSheetReset,
                    onApply: provider.filterSheetApply,
                    isLoading: provider.isLoading,
                  ),
                );
              },
              label: 'filter'.tr(),
              icon: AppStrings.selloutFilterIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.iconFirst = true,
    super.key,
  });

  final VoidCallback onPressed;
  final String label;
  final String icon;
  final bool iconFirst;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorScheme.of(context).onSurface.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (iconFirst) CustomSvgIcon(assetPath: icon, size: 12),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: ColorScheme.of(context).onSurface.withValues(alpha: 0.2),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!iconFirst) CustomSvgIcon(assetPath: icon, size: 12),
          ],
        ),
      ),
    );
  }
}

class ProfilePostSearchField extends StatefulWidget {
  const ProfilePostSearchField({required this.isStore, super.key});
  final bool isStore;

  @override
  State<ProfilePostSearchField> createState() => _ProfilePostSearchFieldState();
}

class _ProfilePostSearchFieldState extends State<ProfilePostSearchField> {
  Timer? _debounce;

  void _onSearchChanged({
    required String value,
    ProfileStorePostsProvider? storeProvider,
    ProfileViewingPostsProvider? viewingProvider,
  }) {
    // Debounce to prevent too many API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (widget.isStore) {
        storeProvider?.loadPosts();
      } else {
        viewingProvider?.loadPosts();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = widget.isStore
        ? context.read<ProfileStorePostsProvider>().queryController
        : context.read<ProfileViewingPostsProvider>().queryController;

    return CustomTextFormField(
      dense: true,
      contentPadding: const EdgeInsets.all(4),
      fieldPadding: const EdgeInsets.all(0),
      controller: controller,
      hint: 'search'.tr(),
      style: TextTheme.of(context).bodyMedium,
      onChanged: (String value) {
        if (widget.isStore) {
          _onSearchChanged(
            value: value,
            storeProvider: context.read<ProfileStorePostsProvider>(),
          );
        } else {
          _onSearchChanged(
            value: value,
            viewingProvider: context.read<ProfileViewingPostsProvider>(),
          );
        }
      },
    );
  }
}
