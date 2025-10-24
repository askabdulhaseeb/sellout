import '../../../../../../../core/enums/listing/property/tenure_type.dart';
import '../form_state/add_listing_form_state.dart';

// Pure Dart mixin, no ChangeNotifier
mixin PropertyListingMixin {
  // The implementing class must provide an instance of AddListingFormState
  AddListingFormState get state;

  // --- Getters (directly from state) ---
  bool get garden => state.hasGarden;
  bool get parking => state.hasParking;
  bool get animalFriendly => state.isAnimalFriendly;
  TenureType get tenureType => state.tenureType;
  String? get selectedPropertyType => state.propertyType;
  String? get selectedEnergyRating => state.energyRating;
  String get selectedPropertySubCategory => state.propertySubCategory;

  // --- Setters (update state and notify listeners) ---
  void setGardenLo(bool? value) {
    if (value == null) return;
    state.hasGarden = value;
  }

  void setParkingLo(bool? value) {
    if (value == null) return;
    state.hasParking = value;
  }

  void setAnimalFriendlyLo(bool? value) {
    if (value == null) return;
    state.isAnimalFriendly = value;
  }

  void setPropertyTypeLo(String? value) {
    state.propertyType = value;
  }

  void setEnergyRatingLo(String? value) {
    state.energyRating = value;
  }

  void setSelectedTenureTypeLo(TenureType value) {
    state.tenureType = value;
  }

  void setSelectedPropertySubTypeLo(String? value) {
    state.propertySubCategory = value ?? '';
  }
}
