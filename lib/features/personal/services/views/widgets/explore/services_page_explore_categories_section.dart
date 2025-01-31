import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../../core/widgets/custom_network_image.dart';

class ServicesPageExploreCategoriesSection extends StatelessWidget {
  const ServicesPageExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ServiceCategoryType> categories = ServiceCategoryType.values;
    return Column(
      mainAxisSize: MainAxisSize.min,
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
              onPressed: () async {},
              child: const Text('see_all').tr(),
            ),
          ],
        ),
        //
        SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final ServiceCategoryType category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          // child: Image.asset(AppImages.logo, fit: BoxFit.cover),
                          child: CustomNetworkImage(
                            imageURL: category.imageURL,
                            size: double.infinity,
                          ),
                        ),
                        Text(
                          category.code,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ).tr(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
