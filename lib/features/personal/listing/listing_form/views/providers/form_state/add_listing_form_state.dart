import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../location/domain/entities/location_entity.dart';
import '../../../../../post/domain/entities/discount_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../data/models/sub_category_model.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../widgets/core/delivery_Section.dart/add_listing_delivery_selection_widget.dart';

class AddListingFormState {
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
  // food drink
  String selectedFoodDrinkSubCategory = ListingType.foodAndDrink.cids.first;

  // Property state
  bool garden = true;
  bool parking = true;
  bool animalFriendly = true;
  String tenureType = 'freehold';
  String? selectedPropertyType;
  String? selectedEnergyRating;
  String selectedPropertySubCategory = ListingType.property.cids.first;

  // Vehicle state
  String? transmissionType;
  String? fuelType;
  String? make;
  String? year;
  String? emission;
  String? selectedBodyType;
  String? selectedVehicleCategory;
  String? selectedMileageUnit;
  ColorOptionEntity? selectedVehicleColor;

  // Pet state
  String? age;
  String? time;
  String? petCategory;
  String? breed;
  bool? vaccinationUpToDate;
  bool? wormAndFleaTreated;
  bool? healthChecked;

  // Cloth state
  String? brand;
  String selectedClothSubCategory = ListingType.clothAndFoot.cids.first;

  // Collections
  final List<DiscountEntity> discounts = <DiscountEntity>[
    DiscountEntity(quantity: 2, discount: 0),
    DiscountEntity(quantity: 3, discount: 0),
    DiscountEntity(quantity: 5, discount: 0),
  ];
  List<SizeColorEntity> sizeColorEntities = <SizeColorEntity>[];

  // Location state
  LocationEntity? selectedMeetupLocation;
  LocationEntity? selectedCollectionLocation;
  LatLng? meetupLatLng;
  LatLng? collectionLatLng;

  void reset() {
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

    selectedClothSubCategory = ListingType.clothAndFoot.cids.first;

    garden = true;
    parking = true;
    animalFriendly = true;
    tenureType = 'freehold';
    selectedPropertyType = null;
    selectedEnergyRating = null;
    selectedPropertySubCategory = ListingType.property.cids.first;

    transmissionType = null;
    fuelType = null;
    make = null;
    year = null;
    emission = null;
    selectedBodyType = null;
    selectedVehicleCategory = null;
    selectedMileageUnit = null;
    selectedVehicleColor = null;

    age = null;
    time = null;
    petCategory = null;
    breed = null;
    vaccinationUpToDate = null;
    wormAndFleaTreated = null;
    healthChecked = null;

    brand = null;
    selectedClothSubCategory = ListingType.clothAndFoot.cids.first;
    sizeColorEntities = <SizeColorEntity>[];

    selectedMeetupLocation = null;
    selectedCollectionLocation = null;
    meetupLatLng = null;
    collectionLatLng = null;

    for (final DiscountEntity element in discounts) {
      element.discount = 0;
    }
  }

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
