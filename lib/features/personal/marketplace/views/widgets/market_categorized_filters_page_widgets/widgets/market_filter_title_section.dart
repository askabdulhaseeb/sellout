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

    final ListingType? category = marketPro.marketplaceCategory;

    String title;
    String subtitle;
    Color? subtitleColor = colorScheme.onSurface.withValues(alpha: 0.6);

    switch (category) {
      case ListingType.items:
        title = 'popular_items'.tr();
        subtitle = '${'find_perfect'.tr()} ${'pouplar'.tr()} ${'items'.tr()}';
        break;
      case ListingType.clothAndFoot:
        title = category != null ? category.json.tr() : '';
        subtitle = '${'find_perfect'.tr()} ${'outfit'.tr()}';
        break;
      case ListingType.vehicle:
        title = category != null ? category.json.tr() : '';
        subtitle =
            '${'find_perfect'.tr()} ${category != null ? category.json.tr() : ''}';
        break;
      case ListingType.foodAndDrink:
        title = category != null ? category.json.tr() : '';
        subtitle = '${'find_perfect'.tr()} ${'meal_and_drink'.tr()}';
        break;
      case ListingType.property:
        title = category != null ? category.json.tr() : '';
        subtitle =
            '${'find_perfect'.tr()} ${category != null ? category.json.tr() : ''}';
        break;
      case ListingType.pets:
        title = category != null ? category.json.tr() : '';
        subtitle =
            '${'find_perfect'.tr()} ${category != null ? category.json.tr() : ''}';
        subtitleColor = colorScheme.outline;
        break;
      default:
        title = '';
        subtitle = '';
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(title, style: textTheme.titleMedium),
          Text(
            subtitle,
            style: textTheme.labelMedium?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
