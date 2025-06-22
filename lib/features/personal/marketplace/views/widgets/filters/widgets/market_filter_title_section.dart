import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          Text(marketPro.marketplaceCategory?.code.tr() ?? '',
              style: textTheme.titleMedium),
          Text(
            '${'find_perfect'.tr()} ${marketPro.marketplaceCategory?.code.tr() ?? ''} ${'items'.tr()}',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.outlineVariant,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
