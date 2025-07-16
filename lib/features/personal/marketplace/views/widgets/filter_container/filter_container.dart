import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../providers/marketplace_provider.dart';
import 'filter_container_gridview.dart';
import 'widgets/cloth_foot_filter/cloth_foot_filter_widget.dart';
import 'widgets/food_drink_filter/food_drink_filter_widget.dart';
import 'widgets/item_filter/item_filter_widget.dart';
import 'widgets/market_filter_container_back_button.dart';
import 'widgets/market_filter_container_buttons.dart';
import 'widgets/market_filter_title_section.dart';
import 'widgets/pets_filter/pets_filter_widget.dart';
import 'widgets/property_filter/property_filter_widget.dart';
import 'widgets/vehicle_filter/vehicle_filter_widget.dart';

class FilterContainer extends StatelessWidget {
  const FilterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MarketPlaceProvider>(
      builder:
          (BuildContext context, MarketPlaceProvider marketPro, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const GoBAckButtonWidget(),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: ColorScheme.of(context).outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const MarketFilterTitleSection(),
                  if (marketPro.marketplaceCategory == ListingType.items)
                    const ItemFilterWidget(),
                  if (marketPro.marketplaceCategory == ListingType.clothAndFoot)
                    MarketClothFootFilterSection(screenWidth: screenWidth),
                  if (marketPro.marketplaceCategory == ListingType.pets)
                    const PetsFilterWIdget(),
                  if (marketPro.marketplaceCategory == ListingType.vehicle)
                    const VehicleFIlterWidget(),
                  if (marketPro.marketplaceCategory == ListingType.property)
                    PropertyFilterSection(screenWidth: screenWidth),
                  if (marketPro.marketplaceCategory == ListingType.foodAndDrink)
                    FoodDrinkFilterSection(screenWidth: screenWidth),
                  const MarketFilterButtons(),
                ],
              ),
            ),
            const MarketPlaceFilterContainerPostsGrid()
          ],
        );
      },
    );
  }
}
