import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../data/sources/local/local_service_categories.dart';
import '../../../../../domain/entity/service_category_entity.dart';
import 'service_category_tile.dart';

class AllServiceCategoriesGridScreen extends StatefulWidget {
  const AllServiceCategoriesGridScreen({super.key});

  @override
  State<AllServiceCategoriesGridScreen> createState() =>
      _AllServiceCategoriesGridScreenState();
}

class _AllServiceCategoriesGridScreenState
    extends State<AllServiceCategoriesGridScreen> {
  @override
  Widget build(BuildContext context) {
    List<ServiceCategoryENtity> categories =
        LocalServiceCategory().getAllCategories();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          titleKey: 'service_categories'.tr(),
        ),
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
            final ServiceCategoryENtity category = categories[index];
            return SeviceCategoryTile(category: category);
          },
        ),
      ),
    );
  }
}
