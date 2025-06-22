import 'package:flutter/material.dart';

import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_food_drink_toggle_button.dart';

class FoodDrinkFilterSection extends StatelessWidget {
  const FoodDrinkFilterSection({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MarketFilterFoodDrinkToggleWidget(
          screenWidth: screenWidth,
        ),
        const MarketFilterSearchField(),
        const MarketFilterPriceWIdget()
      ],
    );
  }
}
