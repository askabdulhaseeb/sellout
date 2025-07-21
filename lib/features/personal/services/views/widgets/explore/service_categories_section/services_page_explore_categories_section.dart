import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/business/services/service_category_type.dart';
import 'widgets/service_category_tile.dart';
import 'widgets/services_categories_grid_section.dart';

class ServicesPageExploreCategoriesSection extends StatelessWidget {
  const ServicesPageExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ServiceCategoryType> categories = ServiceCategoryType.values;
    return Column(
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
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final ServiceCategoryType category = categories[index];
              return SeviceCategoryTile(category: category);
            },
          ),
        ),
      ],
    );
  }
}
