import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/shadow_container.dart';
import 'marketplace_custom_gridview.dart';

class MarketplacePromotedSection extends StatelessWidget {
  const MarketplacePromotedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'promoted'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomMarketplaceGridView<Widget>(
            items: List<Widget>.generate(
          2,
          (int index) => ShadowContainer(
            color: ColorScheme.of(context).outlineVariant,
            borderRadius: BorderRadius.circular(15),
            child: const SizedBox(),
          ),
        )),
        const Divider()
      ],
    );
  }
}
