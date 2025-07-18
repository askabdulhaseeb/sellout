import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../providers/marketplace_provider.dart';

class MarketFilterButtons extends StatelessWidget {
  const MarketFilterButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Column(
        children: <Widget>[
          CustomElevatedButton(
              title: 'search'.tr(),
              isLoading: marketPro.isLoading,
              onTap: () {
                marketPro.loadFilteredContainerPosts();
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => marketPro.resetFilters(),
                child: Text(
                  'reset_filters'.tr(),
                  style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      decorationColor: colorScheme.outlineVariant,
                      color: colorScheme.outlineVariant,
                      decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                child: Text(
                  'more_options'.tr(),
                  style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      decorationColor: colorScheme.outlineVariant,
                      color: colorScheme.outlineVariant,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
