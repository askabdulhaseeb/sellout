import 'package:flutter/material.dart';

import '../../../domain/entities/color_options_entity.dart';

mixin VehicleListingMixin on ChangeNotifier {
  String? _transmissionType;
  String? _fuelType;
  String? _make;
  String? _year;
  String? _emission;
  String? _selectedBodyType;
  String? _selectedVehicleCategory;
  String? _selectedMileageUnit;
  ColorOptionEntity? _selectedVehicleColor;

  // Getters
  String? get transmissionType => _transmissionType;
  String? get fuelType => _fuelType;
  String? get make => _make;
  String? get year => _year;
  String? get emission => _emission;
  String? get selectedBodyType => _selectedBodyType;
  String? get selectedVehicleCategory => _selectedVehicleCategory;
  String? get selectedMileageUnit => _selectedMileageUnit;
  ColorOptionEntity? get selectedVehicleColor => _selectedVehicleColor;

  // Setters
  void setTransmissionType(String? value) {
    _transmissionType = value;
    notifyListeners();
  }

  void setFuelType(String? value) {
    _fuelType = value;
    notifyListeners();
  }

  void setMake(String? value) {
    _make = value;
    notifyListeners();
  }

  void setYear(String? value) {
    _year = value;
    notifyListeners();
  }

  void setEmissionType(String? value) {
    _emission = value;
    notifyListeners();
  }

  void setBodyType(String? type) {
    _selectedBodyType = type;
    notifyListeners();
  }

  void setVehicleCategory(String? type) {
    _selectedVehicleCategory = type;
    notifyListeners();
  }

  void setMileageUnit(String? unit) {
    _selectedMileageUnit = unit;
    notifyListeners();
  }

  void setVehicleColor(ColorOptionEntity? value) {
    _selectedVehicleColor = value;
    notifyListeners();
  }
}
