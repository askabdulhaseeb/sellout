import 'package:hive_flutter/hive_flutter.dart';
import '../../../utilities/app_string.dart';
part 'listing_type.g.dart';

@HiveType(typeId: 9)
enum ListingType {
  @HiveField(0)
  items('items', 'items', 10, AppStrings.selloutAddListingItemIcon,
      <String>['items'], AppStrings.popularmarketplace),
  @HiveField(1)
  clothAndFoot(
      'cloth_foot',
      'clothes-foot',
      10,
      AppStrings.selloutAddListingClothFootIcon,
      <String>[
        'clothes',
        'footwear',
      ],
      AppStrings.clothfootmarketplace),
  @HiveField(2)
  vehicle('vehicles', 'vehicles', 10, AppStrings.selloutAddListingVehicleIcon,
      <String>['vehicles'], AppStrings.vehiclemarketplace),
  @HiveField(3)
  foodAndDrink(
      'food_drink',
      'food-drink',
      10,
      AppStrings.selloutAddListingFoodDrinkIcon,
      <String>['food', 'drink'],
      AppStrings.fooddrinkmarketplace),
  @HiveField(4)
  property(
      'property_buy_sell',
      'property',
      10,
      AppStrings.selloutAddListingPropertyIcon,
      <String>['sale', 'rent'],
      AppStrings.propertymarketplace),
  @HiveField(5)
  pets('pets', 'pets', 10, AppStrings.selloutAddListingPetsIcon,
      <String>['pets'], AppStrings.petsmarketplaceex);

  const ListingType(
    this.code,
    this.json,
    this.noOfPhotos,
    this.icon,
    this.cids,
    this.imagePath,
  );

  final String code;
  final String json;
  final int noOfPhotos;
  final String icon;
  final List<String> cids;
  final String imagePath;

  static ListingType fromJson(String? json) {
    if (json == null) return ListingType.items;
    return ListingType.values.firstWhere(
      (ListingType type) => type.json == json,
      orElse: () => ListingType.items,
    );
  }

  static ListingType fromStrJson(String? json) {
    if (json == null) return ListingType.items;
    return ListingType.values.firstWhere(
      (ListingType type) => type.cids.contains(json),
      orElse: () => ListingType.items,
    );
  }

  static List<ListingType> get list => ListingType.values;
  static List<ListingType> get storeList => values
      .where((ListingType type) =>
          type == pets || type == property || type == vehicle)
      .map((ListingType type) => type)
      .toList();

  static List<ListingType> get viewingList => values
      .where((ListingType type) =>
          type == items || type == foodAndDrink || type == clothAndFoot)
      .map((ListingType type) => type)
      .toList();
}
