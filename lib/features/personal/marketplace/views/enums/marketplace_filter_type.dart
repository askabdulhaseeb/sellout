import '../../../../../core/utilities/app_string.dart';

enum MarketPlaceFilterTypes {
  popular('items', 'popular', AppStrings.popularmarketplace),
  clothesFoot('clothes-foot', 'clothes-foot', AppStrings.clothfootmarketplace),
  vehicles('vehicles', 'vehicles', AppStrings.vehiclemarketplace),
  foodDrink('food-drink', 'food-drink', AppStrings.fooddrinkmarketplace),
  property('property', 'Property', AppStrings.propertymarketplace),
  pets('pets', 'pets', AppStrings.petsmarketplaceex);

  const MarketPlaceFilterTypes(this.json, this.title, this.imagePath);

  final String json;
  final String title;
  final String imagePath;

  static MarketPlaceFilterTypes fromJson(String? json) {
    if (json == null) return MarketPlaceFilterTypes.popular;
    return MarketPlaceFilterTypes.values.firstWhere(
      (MarketPlaceFilterTypes e) => e.json == json,
      orElse: () => MarketPlaceFilterTypes.popular,
    );
  }

  static List<MarketPlaceFilterTypes> get list => MarketPlaceFilterTypes.values;
}
