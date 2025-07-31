import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../providers/marketplace_provider.dart';

class FilterSheetHeaderSection extends StatelessWidget {
  const FilterSheetHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CloseButton(onPressed: () {
            Navigator.pop(context);
          }),
          Text(
            'filter'.tr(),
            style: TextTheme.of(context)
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: () {
              pro.filterSheetResetButton(context);
            },
            child: Text(
              'reset'.tr(),
              style: TextTheme.of(context)
                  .labelSmall
                  ?.copyWith(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
