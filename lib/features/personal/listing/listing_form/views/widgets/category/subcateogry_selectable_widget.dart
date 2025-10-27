import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../data/sources/local/local_categories.dart';
import '../../../domain/entities/sub_category_entity.dart';
import 'category_selection_bottom_sheet.dart';

class SubCategorySelectableWidget<T extends ChangeNotifier>
    extends StatefulWidget {
  const SubCategorySelectableWidget({
    required this.listType,
    required this.subCategory,
    required this.onSelected,
    this.cid,
    this.title = true,
    this.hint = 'select_category',
    this.listenProvider,
    super.key,
  });

  final ListingType? listType;
  final SubCategoryEntity? subCategory;
  final void Function(SubCategoryEntity?) onSelected;
  final String? cid;
  final bool title;
  final String hint;
  final T? listenProvider;

  @override
  State<SubCategorySelectableWidget<T>> createState() =>
      _SubCategorySelectableWidgetState<T>();
}

class _SubCategorySelectableWidgetState<T extends ChangeNotifier>
    extends State<SubCategorySelectableWidget<T>> {
  SubCategoryEntity? selectedSubCategory;
  SubCategoryEntity? selectedSubSubCategory;

  @override
  void initState() {
    super.initState();
    selectedSubCategory = widget.subCategory;
    debugPrint('🟣 [INIT] SubCategorySelectableWidget initialized');
    debugPrint('🟢 Initial selectedSubCategory: ${selectedSubCategory?.title}');
  }

  @override
  void didUpdateWidget(covariant SubCategorySelectableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subCategory != widget.subCategory) {
      debugPrint('🟠 [UPDATE] SubCategory changed');
      setState(() {
        selectedSubCategory = widget.subCategory;
        selectedSubSubCategory = null;
      });
      debugPrint(
          '🟢 Updated selectedSubCategory: ${selectedSubCategory?.title}');
    }
  }

  List<SubCategoryEntity> _getFilteredSubCategories() {
    debugPrint(
        '🔵 [FILTER] Getting filtered subcategories for listType: ${widget.listType?.json}, cid: ${widget.cid}');

    switch (widget.listType) {
      case ListingType.items:
        return LocalCategoriesSource.items?.subCategory ??
            <SubCategoryEntity>[];
      case ListingType.clothAndFoot:
        if (widget.cid == ListingType.clothAndFoot.cids.first) {
          debugPrint('👕 Using clothes subcategories');
          return LocalCategoriesSource.clothes?.subCategory ??
              <SubCategoryEntity>[];
        } else if (widget.cid == ListingType.clothAndFoot.cids.last) {
          debugPrint('👟 Using footwear subcategories');
          return LocalCategoriesSource.foot?.subCategory ??
              <SubCategoryEntity>[];
        }
        debugPrint('⚪ No valid CID found for clothAndFoot');
        return <SubCategoryEntity>[];

      case ListingType.foodAndDrink:
        if (widget.cid == ListingType.foodAndDrink.cids.first) {
          debugPrint('🍔 Using food subcategories');
          return LocalCategoriesSource.food?.subCategory ??
              <SubCategoryEntity>[];
        } else if (widget.cid == ListingType.foodAndDrink.cids.last) {
          debugPrint('🥤 Using drink subcategories');
          return LocalCategoriesSource.drink?.subCategory ??
              <SubCategoryEntity>[];
        }
        debugPrint('⚪ No valid CID found for foodAndDrink');
        return <SubCategoryEntity>[];

      default:
        debugPrint('📦 Using default');
        return <SubCategoryEntity>[];
    }
  }

  Future<void> _handleCategorySelection(
      List<SubCategoryEntity> subCategories, BuildContext context) async {
    debugPrint('🟣 [ACTION] User tapped to select a category');
    debugPrint('📋 Available subcategories: ${subCategories.length}');

    if (subCategories.isEmpty) {
      AppSnackBar.showSnackBar(context, 'no_categories_found'.tr());
      debugPrint('❌ No categories found for selection');
      return;
    }

    final SubCategoryEntity? selected =
        await showModalBottomSheet<SubCategoryEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        debugPrint('🧩 Showing CategorySelectionBottomSheet...');
        return CategorySelectionBottomSheet(subCategories: subCategories);
      },
    );

    if (selected == null) {
      debugPrint('⚪ User closed bottom sheet without selecting');
      return;
    }

    debugPrint('✅ User selected category: ${selected.title}');
    setState(() {
      selectedSubCategory = selected;
      selectedSubSubCategory = null;
    });

    if (selected.subCategory.isEmpty) {
      debugPrint('🔚 No sub-subcategories found, invoking onSelected callback');
      widget.onSelected(selected);
    } else {
      debugPrint('🔁 Subcategory contains nested categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget Function(BuildContext context) builder = _buildMainUI;

    if (widget.listenProvider != null) {
      debugPrint('🟢 Listening to provider changes for rebuild');
      return Consumer<T>(builder: (_, __, ___) => builder(context));
    } else {
      return builder(context);
    }
  }

  Widget _buildMainUI(BuildContext context) {
    final List<SubCategoryEntity> subCategories = _getFilteredSubCategories();
    debugPrint(
        '🧩 [UI] Building main UI, ${subCategories.length} subcategories loaded');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () => _handleCategorySelection(subCategories, context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorScheme.of(context).outline),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedSubCategory?.title ?? widget.hint.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: selectedSubCategory == null
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorScheme.of(context)
                                .onSurface
                                .withValues(alpha: 0.6))
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        // No dropdown for subcategories in any case
      ],
    );
  }
}
