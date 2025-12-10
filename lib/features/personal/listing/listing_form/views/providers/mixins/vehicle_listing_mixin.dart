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
  ColorOptionEntity? get interiorColor => state.interiorColor;
  ColorOptionEntity? get exteriorColor => state.exteriorColor;

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

  void setInteriorColorLo(ColorOptionEntity? value) {
    state.interiorColor = value;
  }

  void setExteriorColorLo(ColorOptionEntity? value) {
    state.exteriorColor = value;
  }
}
