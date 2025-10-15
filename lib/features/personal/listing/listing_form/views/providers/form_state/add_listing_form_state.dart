import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../post/domain/entities/discount_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../domain/entities/sub_category_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../widgets/core/delivery_Section.dart/add_listing_delivery_selection_widget.dart';

class AddListingFormState {
  AddListingFormState() {
    _initializeDefaults();
    //Non-nullable instance field 'clothSubCategory' must be initialized.
// Try adding an initializer expression, or add a field initializer in this constructor, or mark it 'late'.dartnot_initialized_non_nullable_instance_field
// Non-nullable instance field 'foodDrinkSubCategory' must be initialized.
// Try adding an initializer expression, or add a field initializer in this constructor, or mark it 'late'.dartnot_initialized_non_nullable_instance_field
// Non-nullable instance field 'propertySubCategory' must be initialized.
// Try adding an initializer expression, or add a field initializer in this constructor, or mark it 'late'.dartnot_initialized_non_nullable_instance_field
// Constructor declarations should be before non-constructor declarations.
// Try moving the constructor declaration before all other members.da
  }
  // Text controllers
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController quantity = TextEditingController(text: '1');
  final TextEditingController minimumOffer = TextEditingController();
  final TextEditingController engineSize = TextEditingController();
  final TextEditingController mileage = TextEditingController();
  final TextEditingController bedroom = TextEditingController();
  final TextEditingController bathroom = TextEditingController();
  final TextEditingController model = TextEditingController();
  final TextEditingController seats = TextEditingController();
  final TextEditingController doors = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController packageHeight = TextEditingController();
  final TextEditingController packageWidth = TextEditingController();
  final TextEditingController packageLength = TextEditingController();
  final TextEditingController packageWeight = TextEditingController();

  // Core state
  ListingType? listingType;
  SubCategoryEntity? selectedCategory;
  ConditionType condition = ConditionType.newC;
  PrivacyType privacy = PrivacyType.public;
  DeliveryType deliveryType = DeliveryType.paid;
  DeliveryPayer deliveryPayer = DeliveryPayer.sellerPays;

  bool isDiscounted = false;
  bool acceptOffer = true;
  bool isLoading = false;
  bool isDropdownLoading = false;
  String accessCode = '';

  // Pet state
  String? age;
  String? time;
  String? petCategory;
  String? breed;
  bool? vaccinationUpToDate;
  bool? wormAndFleaTreated;
  bool? healthChecked;

  // Vehicle state
  String? transmissionType;
  String? fuelType;
  String? make;
  String? year;
  String? emission;
  String? bodyType;
  String? vehicleCategory;
  String? mileageUnit;
  ColorOptionEntity? vehicleColor;

  // Property state
  bool hasGarden = true;
  bool hasParking = true;
  bool isAnimalFriendly = true;
  String tenureType = 'freehold';
  String? propertyType;
  String? energyRating;
  String? propertySubCategory;

  // Food state
  String? foodDrinkSubCategory;

  // Cloth state
  String? brand;
  String? clothSubCategory;
  List<SizeColorEntity> sizeColorEntities = <SizeColorEntity>[];

  // Collections
  final List<DiscountEntity> discounts = <DiscountEntity>[
    DiscountEntity(quantity: 2, discount: 0),
    DiscountEntity(quantity: 3, discount: 0),
    DiscountEntity(quantity: 5, discount: 0),
  ];

  // Location state
  LocationEntity? selectedMeetupLocation;
  LocationEntity? selectedCollectionLocation;
  LatLng? meetupLatLng;
  LatLng? collectionLatLng;

  void _initializeDefaults() {
    propertySubCategory = _getDefaultCategory(ListingType.property);
    foodDrinkSubCategory = _getDefaultCategory(ListingType.foodAndDrink);
    clothSubCategory = _getDefaultCategory(ListingType.clothAndFoot);
  }

  String _getDefaultCategory(ListingType type) {
    return type.cids.isNotEmpty ? type.cids.first : '';
  }

  void reset() {
    _clearControllers();
    _resetCoreState();
    _resetPetState();
    _resetVehicleState();
    _resetPropertyState();
    _resetFoodState();
    _resetClothState();
    _resetLocationState();
    _resetDiscounts();
  }

  void _clearControllers() {
    title.clear();
    description.clear();
    price.clear();
    quantity.text = '1';
    minimumOffer.clear();
    engineSize.clear();
    mileage.clear();
    bedroom.clear();
    bathroom.clear();
    model.clear();
    seats.clear();
    doors.clear();
    location.clear();
    packageHeight.clear();
    packageWidth.clear();
    packageLength.clear();
    packageWeight.clear();
  }

  void _resetCoreState() {
    listingType = null;
    selectedCategory = null;
    condition = ConditionType.newC;
    privacy = PrivacyType.public;
    deliveryType = DeliveryType.paid;
    deliveryPayer = DeliveryPayer.sellerPays;
    isDiscounted = false;
    acceptOffer = true;
    isLoading = false;
    accessCode = '';
  }

  void _resetPetState() {
    age = null;
    time = null;
    petCategory = null;
    breed = null;
    vaccinationUpToDate = null;
    wormAndFleaTreated = null;
    healthChecked = null;
  }

  void _resetVehicleState() {
    transmissionType = null;
    fuelType = null;
    make = null;
    year = null;
    emission = null;
    bodyType = null;
    vehicleCategory = null;
    mileageUnit = null;
    vehicleColor = null;
  }

  void _resetPropertyState() {
    hasGarden = true;
    hasParking = true;
    isAnimalFriendly = true;
    tenureType = 'freehold';
    propertyType = null;
    energyRating = null;
    propertySubCategory = _getDefaultCategory(ListingType.property);
  }

  void _resetFoodState() {
    foodDrinkSubCategory = _getDefaultCategory(ListingType.foodAndDrink);
  }

  void _resetClothState() {
    brand = null;
    clothSubCategory = _getDefaultCategory(ListingType.clothAndFoot);
    sizeColorEntities.clear();
  }

  void _resetLocationState() {
    selectedMeetupLocation = null;
    selectedCollectionLocation = null;
    meetupLatLng = null;
    collectionLatLng = null;
  }

  void _resetDiscounts() {
    for (final DiscountEntity element in discounts) {
      element.discount = 0;
    }
  }

  // Validation methods
  bool get isTitleValid => title.text.trim().isNotEmpty;
  bool get isDescriptionValid => description.text.trim().isNotEmpty;
  bool get isPriceValid {
    final value = double.tryParse(price.text);
    return value != null && value > 0;
  }

  bool get isQuantityValid {
    final value = int.tryParse(quantity.text);
    return value != null && value > 0;
  }

  bool get isFormValid {
    return isTitleValid &&
        isDescriptionValid &&
        isPriceValid &&
        isQuantityValid;
  }

  // Convenience getters for parsed values
  double? get parsedPrice => double.tryParse(price.text);
  int? get parsedQuantity => int.tryParse(quantity.text);
  int? get parsedBedroom => int.tryParse(bedroom.text);
  int? get parsedBathroom => int.tryParse(bathroom.text);
  double? get parsedEngineSize => double.tryParse(engineSize.text);
  int? get parsedMileage => int.tryParse(mileage.text);
  int? get parsedDoors => int.tryParse(doors.text);
  int? get parsedSeats => int.tryParse(seats.text);

  // Package dimensions getters
  double? get parsedPackageHeight => double.tryParse(packageHeight.text);
  double? get parsedPackageWidth => double.tryParse(packageWidth.text);
  double? get parsedPackageLength => double.tryParse(packageLength.text);
  double? get parsedPackageWeight => double.tryParse(packageWeight.text);

  void dispose() {
    title.dispose();
    description.dispose();
    price.dispose();
    quantity.dispose();
    minimumOffer.dispose();
    engineSize.dispose();
    mileage.dispose();
    bedroom.dispose();
    bathroom.dispose();
    model.dispose();
    seats.dispose();
    doors.dispose();
    location.dispose();
    packageHeight.dispose();
    packageWidth.dispose();
    packageLength.dispose();
    packageWeight.dispose();
  }
}
