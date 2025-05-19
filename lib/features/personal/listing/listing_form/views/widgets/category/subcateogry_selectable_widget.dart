import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
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
    super.key,
  });

  final ListingType? listType;
  final SubCategoryEntity? subCategory;
  final void Function(SubCategoryEntity?) onSelected;

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
      provider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider provider,
          Widget? child) {
        if (provider.isLoading) return const Loader();

        List<ListingEntity> selectedList = <ListingEntity>[];

        if (widget.listType == ListingType.clothAndFoot) {
          selectedList = provider.listings
              .where((ListingEntity e) =>
                  e.listId == provider.selectedClothSubCategory)
              .toList();
        } else if (widget.listType != null) {
          selectedList = provider.listings
              .where((ListingEntity e) => e.type == widget.listType)
              .toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.listType == ListingType.pets
                  ? 'pet_category'.tr()
                  : 'category'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            // First Dropdown
            InkWell(
              onTap: () => _handleCategorySelection(
                  widget.listType!, selectedList, context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedSubCategory?.title ?? 'select_category'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              selectedSubCategory == null ? Colors.grey : null,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            // Second Dropdown (only for pets if sub-sub-categories exist)
            if (widget.listType == ListingType.pets &&
                selectedSubCategory != null &&
                selectedSubCategory!.subCategory.isNotEmpty) ...<Widget>{
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'breed'.tr(), // 👈 Add this label
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  DropdownButtonFormField<SubCategoryEntity>(
                    value: selectedSubSubCategory,
                    items: selectedSubCategory!.subCategory
                        .map(
                          (SubCategoryEntity sub) => DropdownMenuItem(
                            value: sub,
                            child: Text(sub.title),
                          ),
                        )
                        .toList(),
                    onChanged: (SubCategoryEntity? sub) {
                      if (sub != null) {
                        setState(() {
                          selectedSubSubCategory = sub;
                        });
                        widget.onSelected(sub); // Same onSelected
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      hintText: 'select_breed'.tr(),
                    ),
                  ),
                ],
              ),
            }
          ],
        );
      },
    );
  }

  Future<void> _handleCategorySelection(ListingType listType,
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

    final SubCategoryEntity? selected = await showModalBottomSheet(
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

      if (listType == ListingType.pets) {
        Provider.of<AddListingFormProvider>(context, listen: false)
            .setPetCategory(selected.title.toLowerCase());
      }
      // If it's not pets or there's no sub-sub-category, select immediately
      if (listType != ListingType.pets || selected.subCategory.isEmpty) {
        widget.onSelected(selected);
      }
    }
  }
}
