import 'package:flutter/material.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../form_state/add_listing_form_state.dart';

mixin VehicleListingMixin on ChangeNotifier {
  AddListingFormState get state;

  // Getters
  String? get transmissionType => state.transmissionType;
  String? get fuelType => state.fuelType;
  String? get make => state.make;
  String? get year => state.year;
  String? get emission => state.emission;
  String? get selectedBodyType => state.bodyType;
  String? get selectedVehicleCategory => state.vehicleCategory;
  String? get selectedMileageUnit => state.mileageUnit;
  ColorOptionEntity? get selectedVehicleColor => state.vehicleColor;
  String? get interiorColor => state.interiorColor;
  String? get exteriorColor => state.exteriorColor;

  // Setters
  void setTransmissionType(String? value) {
    state.transmissionType = value;
    notifyListeners();
  }

  void setFuelType(String? value) {
    state.fuelType = value;
    notifyListeners();
  }

  void setMake(String? value) {
    state.make = value;
    notifyListeners();
  }

  void setYear(String? value) {
    state.year = value;
    notifyListeners();
  }

  void setEmissionType(String? value) {
    state.emission = value;
    notifyListeners();
  }

  void setBodyType(String? type) {
    state.bodyType = type;
    notifyListeners();
  }

  void setVehicleCategory(String? type) {
    state.vehicleCategory = type;
    notifyListeners();
  }

  void setMileageUnit(String? unit) {
    state.mileageUnit = unit;
    notifyListeners();
  }

  void setVehicleColor(ColorOptionEntity? value) {
    state.vehicleColor = value;
    notifyListeners();
  }

  void setInteriorColor(String? value) {
    state.interiorColor = value;
    notifyListeners();
  }

  void setExteriorColor(String? value) {
    state.exteriorColor = value;
    notifyListeners();
  }
}
