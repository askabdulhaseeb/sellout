import 'package:flutter/material.dart';
import '../form_state/add_listing_form_state.dart';

mixin PetListingMixin on ChangeNotifier {
  AddListingFormState get state;

  // Getters - delegate to state
  String? get age => state.age;
  String? get time => state.time;
  String? get petCategory => state.petCategory;
  String? get breed => state.breed;
  bool? get vaccinationUpToDate => state.vaccinationUpToDate;
  bool? get wormAndFleaTreated => state.wormAndFleaTreated;
  bool? get healthChecked => state.healthChecked;

  // Setters - update state and notify
  void setTime(String? value) {
    if (value == null) return;
    state.time = value;
    notifyListeners();
  }

  void setPetCategory(String? category) {
    state.petCategory = category;
    notifyListeners();
  }

  void setPetBreed(String? value) {
    state.breed = value;
    notifyListeners();
  }

  void setVaccinationUpToDate(bool? value) {
    state.vaccinationUpToDate = value;
    notifyListeners();
  }

  void setWormFleaTreated(bool? value) {
    // Fixed typo: Flee -> Flea
    state.wormAndFleaTreated = value;
    notifyListeners();
  }

  void setHealthChecked(bool? value) {
    state.healthChecked = value;
    notifyListeners();
  }

  void setAge(String? value) {
    if (value == null) return;
    state.age = value;
    notifyListeners();
  }
}
