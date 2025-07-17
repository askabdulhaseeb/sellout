import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../providers/marketplace_provider.dart';

class MarketFilterTitleSection extends StatelessWidget {
  const MarketFilterTitleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          if (marketPro.marketplaceCategory == ListingType.items)
            Column(
              children: <Widget>[
                Text('popular_items'.tr(), style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${'pouplar'.tr()} ${'items'.tr()}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (marketPro.marketplaceCategory == ListingType.clothAndFoot)
            Column(
              children: <Widget>[
                Text(marketPro.marketplaceCategory?.json.tr() ?? '',
                    style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${'outfit'.tr()}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (marketPro.marketplaceCategory == ListingType.vehicle)
            Column(
              children: <Widget>[
                Text(marketPro.marketplaceCategory?.json.tr() ?? '',
                    style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${marketPro.marketplaceCategory?.json.tr() ?? ''}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (marketPro.marketplaceCategory == ListingType.foodAndDrink)
            Column(
              children: <Widget>[
                Text(marketPro.marketplaceCategory?.json.tr() ?? '',
                    style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${'meal_and_drink'.tr()}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (marketPro.marketplaceCategory == ListingType.property)
            Column(
              children: <Widget>[
                Text(marketPro.marketplaceCategory?.json.tr() ?? '',
                    style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${marketPro.marketplaceCategory?.json.tr() ?? ''}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (marketPro.marketplaceCategory == ListingType.pets)
            Column(
              children: <Widget>[
                Text(marketPro.marketplaceCategory?.json.tr() ?? '',
                    style: textTheme.titleMedium),
                Text(
                  '${'find_perfect'.tr()} ${marketPro.marketplaceCategory?.json.tr() ?? ''}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
