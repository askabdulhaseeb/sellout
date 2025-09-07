import 'package:flutter/material.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';

class FoodDrinkFilterSection extends StatelessWidget {
  const FoodDrinkFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        // InDevMode(
        //   child: MarketFilterFoodDrinkToggleWidget(
        //     screenWidth: screenWidth,
        //   ),
        // ),
        MarketFilterSearchField(),
        // MarketFilterFoodDrinkCategoryAndLocationWIdget(),
        MarketFilterPriceWIdget()
      ],
    );
  }
}
