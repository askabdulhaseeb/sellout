import '../form_state/add_listing_form_state.dart';

// Pure Dart mixin, no ChangeNotifier
mixin PetListingMixin {
  AddListingFormState get state;

  // Getters - delegate to state
  String? get age => state.age;
  String? get readyToLeave => state.readyToLeave;
  String? get petCategory => state.petCategory;
  String? get breed => state.breed;
  bool? get vaccinationUpToDate => state.vaccinationUpToDate;
  bool? get wormAndFleaTreated => state.wormAndFleaTreated;
  bool? get healthChecked => state.healthChecked;

  // Setters - update state and notify
  void setReadyToLeaveLo(String? value) {
    if (value == null) return;
    state.readyToLeave = value;
  }

  void setPetCategoryLo(String? category) {
    state.petCategory = category;
  }

  void setPetBreedLo  (String? value) {
    state.breed = value;
  }

  void setVaccinationUpToDateLo(bool? value) {
    state.vaccinationUpToDate = value;
  }

  void setWormFleaTreatedLo(bool? value) {
    state.wormAndFleaTreated = value;
  }

  void setHealthCheckedLo(bool? value) {
    state.healthChecked = value;
  }

  void setAgeLo(String? value) {
    if (value == null) return;
    state.age = value;
  }
}
