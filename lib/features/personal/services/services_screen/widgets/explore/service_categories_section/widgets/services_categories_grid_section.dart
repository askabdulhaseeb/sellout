import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/enums/business/services/service_category_type.dart';
import 'service_category_tile.dart';

class AllServiceCategoriesGridScreen extends StatelessWidget {
  const AllServiceCategoriesGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ServiceCategoryType> categories = ServiceCategoryType.values;

    return Scaffold(
      appBar: AppBar(
        title: Text('categories'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (BuildContext context, int index) {
            final ServiceCategoryType category = categories[index];

            return SeviceCategoryTile(category: category);
          },
        ),
      ),
    );
  }
}
