import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../bottomsheets/categorized_services_bottomsheet.dart';

class ServicesPageExploreCategoriesSection extends StatefulWidget {
  const ServicesPageExploreCategoriesSection({super.key});
  @override
  State<ServicesPageExploreCategoriesSection> createState() =>
      _ServicesPageExploreCategoriesSectionState();
}

class _ServicesPageExploreCategoriesSectionState
    extends State<ServicesPageExploreCategoriesSection> {
  bool showAll = false;

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
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Text(showAll ? 'hide'.tr() : 'see_all'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (showAll)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (BuildContext context, int index) {
              final ServiceCategoryType category = categories[index];
              return _CategoryTile(category: category);
            },
          )
        else
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final ServiceCategoryType category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _CategoryTile(category: category),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final ServiceCategoryType category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCategorizedServicesSheet(context, category),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CustomNetworkImage(
                    imageURL: category.imageURL,
                    placeholder: category.name,
                    size: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    category.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ).tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
