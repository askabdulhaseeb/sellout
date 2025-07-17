import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../enums/marketplace_filter_type.dart';
import '../providers/marketplace_provider.dart';

class MarketPlaceCategoriesSection extends StatelessWidget {
  const MarketPlaceCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketplacePro =
        context.read<MarketPlaceProvider>();
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
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
            itemCount: MarketPlaceFilterTypes.values.length,
            itemBuilder: (BuildContext context, int index) {
              final MarketPlaceFilterTypes category =
                  MarketPlaceFilterTypes.values[index];
              return InkWell(
                onTap: () async {
                  final AddListingFormProvider addListingPro =
                      Provider.of<AddListingFormProvider>(context,
                          listen: false);
                  await addListingPro.fetchDropdownListings(
                    '/category/${category.json}?list-id=',
                  );
                  marketplacePro.setMarketplaceCategory(
                      ListingType.fromJson(category.json));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface,
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
                          color: theme.colorScheme.scrim.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            category.title.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
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
      ),
    );
  }
}
