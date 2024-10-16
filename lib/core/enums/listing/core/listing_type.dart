import 'package:flutter/material.dart';

import '../../../utilities/app_icons.dart';

enum ListingType {
  items(
    'items',
    'items',
    4,
    AppIcons.shoppingBag,
    <String>['items'],
  ),
  clothAndFoot(
    'cloth-foot',
    'cloth-foot',
    4,
    AppIcons.tShirt,
    <String>['clothes', 'footwear'],
  ),
  vehicle(
    'vehicles',
    'vehicles',
    4,
    AppIcons.car,
    <String>['vehicles'],
  ),
  foodAndDrink(
    'food-drink',
    'food-drink',
    4,
    AppIcons.food,
    <String>['food', 'drink'],
  ),
  property(
    'property-buy-sell',
    'property',
    4,
    AppIcons.key,
    <String>['property'],
  ),
  pets(
    'pets',
    'pets',
    4,
    AppIcons.pet,
    <String>['pets'],
  ),
  ;

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

  static List<ListingType> get list => ListingType.values;
}
