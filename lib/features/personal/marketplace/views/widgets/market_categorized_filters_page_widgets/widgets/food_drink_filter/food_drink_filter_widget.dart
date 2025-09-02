import 'package:flutter/material.dart';
import '../market_filter_price_widget.dart';
import '../marketplace_filter_searchfield.dart';
import 'widget/market_filter_food_drink_category_location_widget.dart';

class FoodDrinkFilterSection extends StatelessWidget {
  const FoodDrinkFilterSection({
    required this.screenWidth,
    super.key,
  });

  final double screenWidth;

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
        MarketFilterFoodDrinkCategoryAndLocationWIdget(),
        MarketFilterPriceWIdget()
      ],
    );
  }
}
