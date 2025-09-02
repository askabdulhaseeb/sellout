import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../providers/marketplace_provider.dart';

class FilterSheetSheetButton extends StatelessWidget {
  const FilterSheetSheetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomElevatedButton(
          onTap: () {
            pro.filterSheetApplyButton();
            Navigator.pop(context);
          },
          title: 'apply'.tr(),
          isLoading: pro.isLoading,
        ),
      ),
    );
  }
}
