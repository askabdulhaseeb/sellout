import 'package:flutter/material.dart';

import '../../../../../../../core/enums/listing/core/listing_type.dart';

mixin FoodListingMixin on ChangeNotifier {
  String _selectedFooddDrinkSubCategory = ListingType.foodAndDrink.cids.first;

  // Getters
  String get selectedFoodDrinkSubCategory => _selectedFooddDrinkSubCategory;

  // Setters

  void setSelectedFoodDrinkSubCategory(String value) {
    _selectedFooddDrinkSubCategory = value;
    notifyListeners();
  }
}
