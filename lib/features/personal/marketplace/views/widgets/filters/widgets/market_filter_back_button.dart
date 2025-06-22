import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/marketplace_provider.dart';

class GoBAckButtonWidget extends StatelessWidget {
  const GoBAckButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MarketPlaceProvider marketPro =
        Provider.of<MarketPlaceProvider>(context, listen: false);

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
      icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
      onPressed: () => marketPro.clearMarketplaceCategory(),
      label: Text('go_back'.tr()),
    );
  }
}
