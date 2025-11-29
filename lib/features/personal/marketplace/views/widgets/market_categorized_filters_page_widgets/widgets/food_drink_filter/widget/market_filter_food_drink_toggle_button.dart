import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../providers/marketplace_provider.dart';

class MarketFilterFoodDrinkToggleWidget extends StatelessWidget {
  const MarketFilterFoodDrinkToggleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> subCategories =
        ListingType.foodAndDrink.cids.getRange(0, 2).toList();
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider marketPro,
              Widget? child) =>
          Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorScheme.of(context).outline),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CustomToggleSwitch<String>(
                  verticalMargin: 2,
                  horizontalMargin: 2,
                  containerHeight: 40,
                  verticalPadding: 8,
                  unseletedBorderColor: Colors.transparent,
                  isShaded: false,
                  labels: subCategories,
                  labelStrs: subCategories.map((String e) => e.tr()).toList(),
                  labelText: '',
                  initialValue: marketPro.foodDrinkCategory,
                  onToggle: (String p0) => marketPro.setFoodDrinkCategory(p0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
