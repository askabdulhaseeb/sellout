import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/loaders/loader.dart';
import '../../../data/sources/remote/listing_api.dart';
import '../../../domain/entities/listing_entity.dart';
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
    this.listenProvider,
    super.key,
  });

  final ListingType? listType;
  final SubCategoryEntity? subCategory;
  final void Function(SubCategoryEntity?) onSelected;
  final String? cid;
  final bool title;
  final T? listenProvider;

  @override
  State<SubCategorySelectableWidget<T>> createState() =>
      _SubCategorySelectableWidgetState<T>();
}

class _SubCategorySelectableWidgetState<T extends ChangeNotifier>
    extends State<SubCategorySelectableWidget<T>> {
  SubCategoryEntity? selectedSubCategory;
  SubCategoryEntity? selectedSubSubCategory;
  List<ListingEntity> allListings = <ListingEntity>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedSubCategory = widget.subCategory;
    selectedSubSubCategory = null;
    _fetchCategories();
  }

  @override
  void didUpdateWidget(covariant SubCategorySelectableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subCategory != widget.subCategory) {
      setState(() {
        selectedSubCategory = widget.subCategory;
        selectedSubSubCategory = null;
      });
    }
  }

  Future<void> _fetchCategories() async {
    setState(() => isLoading = true);

    try {
      final List<ListingEntity> listings = await ListingAPI().listing();

      if (!mounted) return;

      if (listings.isEmpty) {
        AppSnackBar.showSnackBar(
          context,
          'no_categories_found'.tr(),
        );
      }

      setState(() {
        allListings = listings;
        isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('Error fetching listings: $e\n$stack');

      if (!mounted) return;
      setState(() => isLoading = false);

      AppSnackBar.showSnackBar(
        context,
        'failed_to_load_categories'.tr(),
      );
    }
  }

  Future<void> _handleCategorySelection(
      List<ListingEntity> selectedList, BuildContext context) async {
    if (selectedList.isEmpty) {
      AppSnackBar.showSnackBar(
        context,
        'no_categories_available'.tr(),
      );
      return;
    }

    final List<SubCategoryEntity> subCategories =
        selectedList.first.subCategory;

    if (subCategories.isEmpty) {
      AppSnackBar.showSnackBar(
        context,
        'no_subcategories_available'.tr(),
      );
      return;
    }

    final SubCategoryEntity? selected =
        await showModalBottomSheet<SubCategoryEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CategorySelectionBottomSheet(
        subCategories: subCategories,
      ),
    );

    if (selected == null) {
      // User closed bottom sheet without selecting
      return;
    }

    setState(() {
      selectedSubCategory = selected;
      selectedSubSubCategory = null;
    });

    if (selected.subCategory.isEmpty) {
      widget.onSelected(selected);
    }
  }

  List<ListingEntity> _filteredListings() {
    if (widget.listType == ListingType.clothAndFoot) {
      return allListings
          .where((ListingEntity e) => e.cid == widget.cid)
          .toList();
    } else if (widget.listType != null) {
      return allListings
          .where((ListingEntity e) => e.listId == widget.listType?.json)
          .toList();
    }
    return allListings;
  }

  @override
  Widget build(BuildContext context) {
    final Widget Function(BuildContext context) builder = _buildMainUI;

    // If a provider is passed, wrap with Consumer
    if (widget.listenProvider != null) {
      return Consumer<T>(
        builder: (_, __, ___) => builder(context),
      );
    } else {
      return builder(context);
    }
  }

  Widget _buildMainUI(BuildContext context) {
    if (isLoading) return const Loader();

    final List<ListingEntity> selectedList = _filteredListings();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title)
          Text('category'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500)),
        if (widget.title) const SizedBox(height: 4),
        InkWell(
          onTap: () => _handleCategorySelection(selectedList, context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 26, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorScheme.of(context).outlineVariant),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedSubCategory?.title ?? 'select_category'.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: selectedSubCategory == null
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: ColorScheme.of(context).outline)
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: ColorScheme.of(context).outline),
              ],
            ),
          ),
        ),
        if (selectedSubCategory != null &&
            selectedSubCategory!.subCategory.isNotEmpty)
          CustomDropdown<SubCategoryEntity>(
            validator: (bool? sub) {
              if (selectedSubCategory!.subCategory.isNotEmpty && sub == null) {
                return 'please_select_sub_category'.tr();
              }
              return null;
            },
            title: 'sub_category'.tr(),
            selectedItem: selectedSubSubCategory,
            items: selectedSubCategory!.subCategory
                .map((SubCategoryEntity e) =>
                    DropdownMenuItem<SubCategoryEntity>(
                      value: e,
                      child: Text(e.title),
                    ))
                .toList(),
            onChanged: (SubCategoryEntity? sub) {
              setState(() {
                selectedSubSubCategory = sub;
              });
              widget.onSelected(sub);
            },
          ),
      ],
    );
  }
}
