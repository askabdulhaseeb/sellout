import '../../../domain/entities/color_options_entity.dart';
import '../form_state/add_listing_form_state.dart';

// Pure Dart mixin, no ChangeNotifier
mixin VehicleListingMixin {
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
  void setTransmissionTypeLo(String? value) {
    state.transmissionType = value;
  }

  void setFuelTypeLo(String? value) {
    state.fuelType = value;
  }

  void setMakeLo(String? value) {
    state.make = value;
  }

  void setYearLo(String? value) {
    state.year = value;
  }

  void setEmissionTypeLo(String? value) {
    state.emission = value;
  }

  void setBodyTypeLo(String? type) {
    state.bodyType = type;
  }

  void setVehicleCategoryLo(String? type) {
    state.vehicleCategory = type;
  }

  void setMileageUnitLo(String? unit) {
    state.mileageUnit = unit;
  }

  void setVehicleColorLo(ColorOptionEntity? value) {
    state.vehicleColor = value;
  }

  void setInteriorColorLo(String? value) {
    state.interiorColor = value;
  }

  void setExteriorColorLo(String? value) {
    state.exteriorColor = value;
  }

}
