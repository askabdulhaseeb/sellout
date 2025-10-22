import 'package:flutter/material.dart';
import '../../../../../../../core/enums/listing/property/tenure_type.dart';
import '../form_state/add_listing_form_state.dart';

mixin PropertyListingMixin on ChangeNotifier {
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
  void setGarden(bool? value) {
    if (value == null) return;
    state.hasGarden = value;
    notifyListeners();
  }

  void setParking(bool? value) {
    if (value == null) return;
    state.hasParking = value;
    notifyListeners();
  }

  void setAnimalFriendly(bool? value) {
    if (value == null) return;
    state.isAnimalFriendly = value;
    notifyListeners();
  }

  void setPropertyType(String? value) {
    state.propertyType = value;
    notifyListeners();
  }

  void setEnergyRating(String? value) {
    state.energyRating = value;
    notifyListeners();
  }

  void setSelectedTenureType(TenureType value) {
    state.tenureType = value;
    notifyListeners();
  }

  void setSelectedPropertySubType(String? value) {
    state.propertySubCategory = value ?? '';
    notifyListeners();
  }
}
