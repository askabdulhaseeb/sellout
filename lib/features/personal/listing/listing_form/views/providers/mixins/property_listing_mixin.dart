import 'package:flutter/material.dart';

mixin PropertyListingMixin on ChangeNotifier {
  bool _garden = true;
  bool _parking = true;
  bool _animalFriendly = true;
  String _tenureType = 'freehold';
  String? _selectedPropertyType;
  String? _selectedEnergyRating;
  String _selectedPropertySubCategory = 'property_default';

  // Getters
  bool get garden => _garden;
  bool get parking => _parking;
  bool get animalFriendly => _animalFriendly;
  String get tenureType => _tenureType;
  String? get selectedPropertyType => _selectedPropertyType;
  String? get selectedEnergyRating => _selectedEnergyRating;
  String get selectedPropertySubCategory => _selectedPropertySubCategory;

  // Setters
  void setGarden(bool? value) {
    if (value == null) return;
    _garden = value;
    notifyListeners();
  }

  void setParking(bool? value) {
    if (value == null) return;
    _parking = value;
    notifyListeners();
  }

  void setAnimalFriendly(bool? value) {
    if (value == null) return;
    _animalFriendly = value;
    notifyListeners();
  }

  void setPropertyType(String? value) {
    _selectedPropertyType = value;
    notifyListeners();
  }

  void setEnergyRating(String? value) {
    _selectedEnergyRating = value;
    notifyListeners();
  }

  void setSelectedTenureType(String value) {
    _tenureType = value;
    notifyListeners();
  }

  void setSelectedPropertySubCategory(String value) {
    _selectedPropertySubCategory = value;
    notifyListeners();
  }
}
