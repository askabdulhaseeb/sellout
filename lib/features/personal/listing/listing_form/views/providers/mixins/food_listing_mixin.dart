import 'package:flutter/material.dart';

import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../form_state/add_listing_form_state.dart';

mixin FoodListingMixin on ChangeNotifier {
  // The state will be provided by the class implementing this mixin
  AddListingFormState get state;

  // Getters that use the state
  String get selectedFoodDrinkSubCategory =>
      state.foodDrinkSubCategory ?? ListingType.foodAndDrink.cids.first;

  // Setters that update the state
  void setSelectedFoodDrinkSubCategory(String value) {
    state.foodDrinkSubCategory = value;
    state.selectedCategory = null;
    notifyListeners();
  }
}
