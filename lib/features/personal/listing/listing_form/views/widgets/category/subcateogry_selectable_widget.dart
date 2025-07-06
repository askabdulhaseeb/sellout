import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../../../core/widgets/loader.dart';
import '../../../domain/entities/listing_entity.dart';
import '../../../domain/entities/sub_category_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import 'category_selection_bottom_sheet.dart';

class SubCategorySelectableWidget extends StatefulWidget {
  const SubCategorySelectableWidget({
    required this.listType,
    required this.subCategory,
    required this.onSelected,
    this.cid,
    this.title = true,
    super.key,
  });

  final ListingType? listType;
  final SubCategoryEntity? subCategory;
  final void Function(SubCategoryEntity?) onSelected;
  final String? cid;
  final bool title;

  @override
  State<SubCategorySelectableWidget> createState() =>
      _SubCategorySelectableWidgetState();
}

class _SubCategorySelectableWidgetState
    extends State<SubCategorySelectableWidget> {
  SubCategoryEntity? selectedSubCategory;
  SubCategoryEntity? selectedSubSubCategory;

  @override
  void initState() {
    super.initState();
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context, listen: false);
    selectedSubCategory = widget.subCategory;
    selectedSubSubCategory = null;

    if (provider.listings.isEmpty) {
      provider.fetchCategories(provider.listingType?.json ?? '', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider provider, _) {
        if (provider.isLoading) return const Loader();

        List<ListingEntity> selectedList = <ListingEntity>[];

        if (widget.listType == ListingType.clothAndFoot) {
          // Apply special filter by CIDs (cloth and foot filteration)
          selectedList = provider.listings
              .where((ListingEntity e) => e.cid == widget.cid)
              .toList();
        } else if (widget.listType != null) {
          // Normal filter by type
          selectedList = provider.listings
              .where((ListingEntity e) => e.type == widget.listType)
              .toList();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.title)
              Text(
                'category'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
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
                  border:
                      Border.all(color: ColorScheme.of(context).outlineVariant),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedSubCategory?.title ?? 'select_category'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: selectedSubCategory == null
                            ? TextTheme.of(context).bodyMedium?.copyWith(
                                  color: ColorScheme.of(context).outlineVariant,
                                )
                            : TextTheme.of(context).bodyMedium,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: ColorScheme.of(context).outline,
                    ),
                  ],
                ),
              ),
            ),
            if (selectedSubCategory != null &&
                selectedSubCategory!.subCategory.isNotEmpty)
              CustomDropdown<SubCategoryEntity>(
                validator: (bool? sub) {
                  if (selectedSubCategory!.subCategory.isNotEmpty &&
                      sub == null) {
                    return 'please_select_sub_category'.tr();
                  }
                  return null;
                },
                title: 'sub_category'.tr(),
                selectedItem: selectedSubSubCategory,
                items: selectedSubCategory!.subCategory
                    .map(
                      (SubCategoryEntity sub) =>
                          DropdownMenuItem<SubCategoryEntity>(
                        value: sub,
                        child: Text(
                          sub.title,
                          style: TextTheme.of(context).bodyMedium,
                        ),
                      ),
                    )
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
      },
    );
  }

  Future<void> _handleCategorySelection(
      List<ListingEntity> selectedList, BuildContext context) async {
    if (selectedList.isEmpty) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return;
    }

    final ListingEntity selectedCategory = selectedList.first;
    final List<SubCategoryEntity> subCategories = selectedCategory.subCategory;

    if (subCategories.isEmpty) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return;
    }

    final SubCategoryEntity? selected =
        await showModalBottomSheet<SubCategoryEntity>(
      context: context,
      builder: (_) => CategorySelectionBottomSheet(
        subCategories: subCategories,
      ),
    );

    if (selected != null) {
      setState(() {
        selectedSubCategory = selected;
        selectedSubSubCategory = null;
      });

      if (selected.subCategory.isEmpty) {
        widget.onSelected(selected);
      }
    }
  }
}
