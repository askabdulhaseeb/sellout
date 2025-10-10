import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../domain/entities/sub_category_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class CategorySelectionBottomSheet extends StatefulWidget {
  const CategorySelectionBottomSheet({required this.subCategories, super.key});
  final List<SubCategoryEntity> subCategories;

  @override
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends State<CategorySelectionBottomSheet> {
  final List<SubCategoryEntity> selectedSubCategoryStack =
      <SubCategoryEntity>[];

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        // ===== HEADER =====
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                if (selectedSubCategoryStack.isEmpty) {
                  Navigator.pop(context);
                } else {
                  setState(() => selectedSubCategoryStack.removeLast());
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Opacity(
                opacity: 0.7,
                child: Text(
                  selectedSubCategoryStack.isEmpty
                      ? 'select_category'.tr()
                      : selectedSubCategoryStack.last.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        const Divider(height: 1),

        // ===== CATEGORY LIST =====
        Flexible(
          child: ListView.builder(
            itemCount: selectedSubCategoryStack.isEmpty
                ? widget.subCategories.length
                : selectedSubCategoryStack.last.subCategory.length,
            itemBuilder: (BuildContext context, int index) {
              final SubCategoryEntity subCategory =
                  selectedSubCategoryStack.isEmpty
                      ? widget.subCategories[index]
                      : selectedSubCategoryStack.last.subCategory[index];

              return ListTile(
                title: Text(subCategory.title),
                trailing: subCategory.subCategory.isEmpty
                    ? null
                    : const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (subCategory.subCategory.isEmpty) {
                    Navigator.pop(context, subCategory);
                    return;
                  }

                  if (formPro.listingType == ListingType.pets) {
                    Navigator.pop(context, subCategory);
                    return;
                  }

                  setState(() => selectedSubCategoryStack.add(subCategory));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
