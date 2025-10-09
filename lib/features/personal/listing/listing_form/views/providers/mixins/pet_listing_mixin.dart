import 'package:flutter/material.dart';

mixin PetListingMixin on ChangeNotifier {
  String? _age;
  String? _time;
  String? _petCategory;
  String? _breed;
  bool? _vaccinationUpToDate;
  bool? _wormAndFleaTreated;
  bool? _healthChecked;

  // Getters
  String? get age => _age;
  String? get time => _time;
  String? get petCategory => _petCategory;
  String? get breed => _breed;
  bool? get vaccinationUpToDate => _vaccinationUpToDate;
  bool? get wormAndFleaTreated => _wormAndFleaTreated;
  bool? get healthChecked => _healthChecked;

  // Setters
  void setTime(String? value) {
    if (value == null) return;
    _time = value;
    notifyListeners();
  }

  void setPetCategory(String? category) {
    _petCategory = category;
    notifyListeners();
  }

  void setPetBreed(String? value) {
    _breed = value;
    notifyListeners();
  }

  void setVaccinationUpToDate(bool? value) {
    _vaccinationUpToDate = value;
    notifyListeners();
  }

  void setWormFleeTreated(bool? value) {
    _wormAndFleaTreated = value;
    notifyListeners();
  }

  void setHealthChecked(bool? value) {
    _healthChecked = value;
    notifyListeners();
  }

  void setAge(String? value) {
    if (value == null) return;
    _age = value;
    notifyListeners();
  }
}
