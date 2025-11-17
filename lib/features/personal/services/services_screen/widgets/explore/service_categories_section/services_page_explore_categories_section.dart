import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entity/service_category_entity.dart';
import '../../../providers/services_page_provider.dart';
import 'widgets/service_category_tile.dart';
import 'widgets/services_categories_grid_section.dart';

class ServicesPageExploreCategoriesSection extends StatelessWidget {
  const ServicesPageExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'categories'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<AllServiceCategoriesGridScreen>(
                    builder: (_) => const AllServiceCategoriesGridScreen(),
                  ),
                );
              },
              child: Text(
                'see_all'.tr(),
                style: TextTheme.of(context).bodyMedium,
              ),
            ),
          ],
        ),
        Consumer<ServicesPageProvider>(
          builder:
              (BuildContext context, ServicesPageProvider pro, Widget? child) {
            final List<ServiceCategoryEntity> categories =
                pro.serviceCategories;
            // Show actual list when loaded
            return SizedBox(
              height: 110,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final ServiceCategoryEntity category = categories[index];
                  return SeviceCategoryTile(category: category);
                },
              ),
            );
          },
        )
      ],
    );
  }
}
