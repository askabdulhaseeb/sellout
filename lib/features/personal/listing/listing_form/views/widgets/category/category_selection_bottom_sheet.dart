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
  List<SubCategoryEntity> selectedSubCategoryStack = <SubCategoryEntity>[];
  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          selectedSubCategoryStack.isEmpty
              ? Opacity(
                  opacity: 0.5,
                  child: const Text(
                    'select_category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                )
              : Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedSubCategoryStack.removeLast();
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(selectedSubCategoryStack.last.address ?? ''),
                  ],
                ),
          //
          const Divider(),
          //
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: selectedSubCategoryStack.isEmpty
                  ? widget.subCategories.length
                  : selectedSubCategoryStack.last.subCategory.length,
              itemBuilder: (BuildContext context, int index) {
                final SubCategoryEntity subCategory =
                    selectedSubCategoryStack.isEmpty
                        ? widget.subCategories[index]
                        : selectedSubCategoryStack.last.subCategory[index];
                return ListTile(
                  onTap: () {
                    if (subCategory.subCategory.isEmpty) {
                      Navigator.of(context).pop(subCategory);
                      return;
                    }
                    if (formPro.listingType == ListingType.pets &&
                        subCategory.subCategory.isNotEmpty) {
                      // Assuming you have a provider named `BreedProvider`, update the breeds list based on the selected category.
                      // This will be handled in the provider.
                      // You could pass this category info to update the breed dropdown in another screen or widget.

                      Navigator.of(context).pop(subCategory);
                      setState(() {
                        selectedSubCategoryStack.add(subCategory);
                      });
                    } else {
                      setState(() {
                        selectedSubCategoryStack.add(subCategory);
                      });
                    }
                  },
                  title: Text(subCategory.title),
                  trailing: subCategory.subCategory.isEmpty
                      ? const SizedBox()
                      : const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
