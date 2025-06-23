import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../providers/marketplace_provider.dart';

class ExploreCategoriesSection extends StatelessWidget {
  const ExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketplacePro =
        context.read<MarketPlaceProvider>();
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('discover_categories'.tr(), style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: ListingType.values.length,
          itemBuilder: (BuildContext context, int index) {
            final ListingType category = ListingType.values[index];
            return InkWell(
              onTap: () {
                AddListingFormProvider addListingPro =
                    Provider.of<AddListingFormProvider>(context, listen: false);
                addListingPro.fetchDropdownListings(
                    '/category/${marketplacePro.marketplaceCategory?.json}?list-id=');
                marketplacePro.setPosts(<PostEntity>[]);
                marketplacePro.setMarketplaceCategory(category);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        category.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          category.code.tr(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }
}
