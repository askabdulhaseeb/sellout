import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../form_state/add_listing_form_state.dart';

// Pure Dart mixin, no ChangeNotifier
mixin FoodListingMixin {
  // The state will be provided by the class implementing this mixin
  AddListingFormState get state;
  String get selectedFoodDrinkSubCategory {
    if (state.foodDrinkSubCategory.isEmpty) {
      return ListingType.foodAndDrink.cids.first;
    }
    return state.foodDrinkSubCategory;
  }

  // Setters that update the state
  void setSelectedFoodDrinkSubCategoryLo(String value) {
    state.foodDrinkSubCategory = value;
    state.selectedCategory = null;
  }
}
