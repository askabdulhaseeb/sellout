import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_food_drink_category_location_widget.dart';
import 'widget/market_filter_food_drink_toggle_button.dart';

class FoodDrinkFilterSection extends StatelessWidget {
  const FoodDrinkFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: AppSpacing.vSm,
      children: <Widget>[
        MarketFilterFoodDrinkToggleWidget(),
        MarketFilterSearchField(),
        MarketFilterFoodDrinkCategoryAndLocationWIdget(),
        MarketFilterPriceWIdget()
      ],
    );
  }
}
