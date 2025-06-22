import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../utilities/app_icons.dart';
import '../../../utilities/app_string.dart';
part 'listing_type.g.dart';

@HiveType(typeId: 9)
enum ListingType {
  @HiveField(0)
  items('items', 'items', 4, AppIcons.shoppingBag, <String>['items'],
      AppStrings.popularmarketplace),
  @HiveField(1)
  clothAndFoot(
      'cloth_foot',
      'clothes-foot',
      4,
      AppIcons.tShirt,
      <String>['clothes', 'footwear', 'clothes-foot'],
      AppStrings.clothfootmarketplace),
  @HiveField(2)
  vehicle('vehicles', 'vehicles', 4, AppIcons.car, <String>['vehicles'],
      AppStrings.vehiclemarketplace),
  @HiveField(3)
  foodAndDrink('food_drink', 'food-drink', 4, AppIcons.food,
      <String>['food', 'drink', 'food-drink'], AppStrings.fooddrinkmarketplace),
  @HiveField(4)
  property('property_buy_sell', 'property', 4, AppIcons.key,
      <String>['sale', 'rent'], AppStrings.propertymarketplace),
  @HiveField(5)
  pets('pets', 'pets', 4, AppIcons.pet, <String>['pets'],
      AppStrings.petsmarketplaceex);

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
  final IconData icon;
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
}
