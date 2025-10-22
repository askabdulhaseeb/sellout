import 'package:flutter/material.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/enums/listing/property/tenure_type.dart';

mixin PropertyListingMixin on ChangeNotifier {
  bool _garden = true;
  bool _parking = true;
  bool _animalFriendly = true;
  TenureType _tenureType = TenureType.freehold;
  String? _selectedPropertyType;
  String? _selectedEnergyRating;
  String? _selectedPropertySubCategory = ListingType.property.cids.first;

  // Getters
  bool get garden => _garden;
  bool get parking => _parking;
  bool get animalFriendly => _animalFriendly;
  TenureType get tenureType => _tenureType;
  String? get selectedPropertyType => _selectedPropertyType;
  String? get selectedEnergyRating => _selectedEnergyRating;
  String? get selectedPropertySubCategory => _selectedPropertySubCategory;

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

  void setSelectedTenureType(TenureType value) {
    _tenureType = value;
    notifyListeners();
  }

  void setSelectedPropertySubType(String? value) {
    _selectedPropertySubCategory = value;
    notifyListeners();
  }
}
