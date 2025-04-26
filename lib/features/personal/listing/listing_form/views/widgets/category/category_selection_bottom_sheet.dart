import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/sub_category_entity.dart';

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
