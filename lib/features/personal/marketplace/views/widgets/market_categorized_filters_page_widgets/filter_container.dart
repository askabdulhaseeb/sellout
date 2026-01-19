import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../providers/marketplace_provider.dart';
import 'widgets/cloth_foot_filter/cloth_foot_filter_widget.dart';
import 'widgets/food_drink_filter/food_drink_filter_widget.dart';
import 'widgets/item_filter/item_filter_widget.dart';
import 'widgets/market_filter_container_buttons.dart';
import 'widgets/market_filter_title_section.dart';
import 'widgets/pets_filter/pets_filter_widget.dart';
import 'widgets/property_filter/property_filter_widget.dart';
import 'widgets/vehicle_filter/vehicle_filter_widget.dart';

class MarketFilterContainer extends StatelessWidget {
  const MarketFilterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketPlaceProvider marketPro = Provider.of<MarketPlaceProvider>(
      context,
      listen: false,
    );
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorScheme.of(context).outline),
        image: DecorationImage(
          image: AssetImage(marketPro.marketplaceCategory?.imagePath ?? ''),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const MarketFilterTitleSection(),
          if (marketPro.marketplaceCategory == ListingType.items)
            const ItemFilterWidget(),
          if (marketPro.marketplaceCategory == ListingType.clothAndFoot)
            const MarketClothFootFilterSection(),
          if (marketPro.marketplaceCategory == ListingType.pets)
            const PetsFilterWIdget(),
          if (marketPro.marketplaceCategory == ListingType.vehicle)
            const VehicleFIlterWidget(),
          if (marketPro.marketplaceCategory == ListingType.property)
            const PropertyFilterSection(),
          if (marketPro.marketplaceCategory == ListingType.foodAndDrink)
            const FoodDrinkFilterSection(),
          const MarketFilterButtons(),
        ],
      ),
    );
  }
}
