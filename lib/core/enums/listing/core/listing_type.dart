import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../utilities/app_icons.dart';
part 'listing_type.g.dart';

@HiveType(typeId: 9)
enum ListingType {
  @HiveField(0)
  items(
    'items',
    'items',
    4,
    AppIcons.shoppingBag,
    <String>['items'],
  ),
  @HiveField(1)
  clothAndFoot(
    'cloth-foot',
    'cloth-foot',
    4,
    AppIcons.tShirt,
    <String>['clothes', 'footwear', 'cloth-foot'],
  ),
  @HiveField(2)
  vehicle(
    'vehicles',
    'vehicles',
    4,
    AppIcons.car,
    <String>['vehicles'],
  ),
  @HiveField(3)
  foodAndDrink(
    'food-drink',
    'food-drink',
    4,
    AppIcons.food,
    <String>['food', 'drink', 'food-drink'],
  ),
  @HiveField(4)
  property(
    'property-buy-sell',
    'property',
    4,
    AppIcons.key,
    <String>['property'],
  ),
  @HiveField(5)
  pets(
    'pets',
    'pets',
    4,
    AppIcons.pet,
    <String>['pets'],
  );

  const ListingType(
    this.code,
    this.json,
    this.noOfPhotos,
    this.icon,
    this.cids,
  );

  final String code;
  final String json;
  final int noOfPhotos;
  final IconData icon;
  final List<String> cids;

  static ListingType fromJson(String json) {
    return ListingType.values
        .firstWhere((ListingType type) => type.json == json);
  }

  static ListingType fromStrJson(String json) {
    return ListingType.values
        .firstWhere((ListingType type) => type.cids.contains(json));
  }

  static List<ListingType> get list => ListingType.values;
}
