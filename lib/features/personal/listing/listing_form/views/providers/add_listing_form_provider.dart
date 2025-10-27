import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../post/domain/entities/meetup/availability_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/post/post_cloth_foot_entity.dart';
import '../../../../post/domain/entities/post/package_detail_entity.dart';
import '../../../../post/domain/entities/post/post_food_drink_entity.dart';
import '../../../../post/domain/entities/post/post_item_entity.dart';
import '../../../../post/domain/entities/post/post_pet_entity.dart';
import '../../../../post/domain/entities/post/post_property_entity.dart';
import '../../../../post/domain/entities/post/post_vehicle_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/sources/local/local_categories.dart';
import '../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../domain/entities/color_options_entity.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecase/add_listing_usecase.dart';
import '../../domain/usecase/edit_listing_usecase.dart';
import '../params/add_listing_param.dart';
import '../screens/add_listing_form_screen.dart';
import '../screens/add_listing_preview_screen.dart';
import '../widgets/core/delivery_section/enums/delivery_payer.dart';
import 'form_state/add_listing_form_state.dart';
import 'managers/availability_manager.dart';
import 'managers/attachment_manager.dart';
import 'mixins/cloth_listing_mixin.dart';
import 'mixins/food_listing_mixin.dart';
import 'mixins/pet_listing_mixin.dart';
import 'mixins/property_listing_mixin.dart';
import 'mixins/vehicle_listing_mixin.dart';
import '../../../../../../core/enums/listing/property/tenure_type.dart';

class AddListingFormProvider extends ChangeNotifier
    with
        PetListingMixin,
        VehicleListingMixin,
        PropertyListingMixin,
        FoodListingMixin,
        ClothListingMixin {
  AddListingFormProvider(
    this._addListingUsecase,
    this._editListingUsecase,
  );

  final AddListingUsecase _addListingUsecase;
  final EditListingUsecase _editListingUsecase;

  final AddListingFormState _state = AddListingFormState();
  final AvailabilityManager _availabilityManager = AvailabilityManager();
  final AttachmentManager _attachmentManager = AttachmentManager();

  PostEntity? _post;
  final List<ListingEntity> _listings = <ListingEntity>[];

  // Form keys
  final GlobalKey<FormState> itemKey = GlobalKey<FormState>();
  final GlobalKey<FormState> clothesAndFootKey = GlobalKey<FormState>();
  final GlobalKey<FormState> vehicleKey = GlobalKey<FormState>();
  final GlobalKey<FormState> foodAndDrinkKey = GlobalKey<FormState>();
  final GlobalKey<FormState> propertyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> petKey = GlobalKey<FormState>();
  double parseNum(String s) => double.tryParse(s) ?? 0.0;

  PackageDetailEntity? get pkgDetails => PackageDetailEntity(
        length: parseNum(packageLength.text),
        width: parseNum(packageWidth.text),
        height: parseNum(packageHeight.text),
        weight: parseNum(packageWeight.text),
      );

  // Mixin state accessor
  @override
  AddListingFormState get state => _state;

  // Cloth mixin setters

  void setBrand(String? value) {
    setBrandLo(value);
  }

  void setSelectedClothSubCategory(String value) {
    setSelectedClothSubCategoryLo(value);
    notifyListeners();
  }

  void addOrUpdateSizeColorQuantity(
      {required String size,
      required ColorOptionEntity color,
      required int quantity}) {
    addOrUpdateSizeColorQuantityLo(
        size: size, color: color, quantity: quantity);
  }

  void removeColorFromSize({required String size, required String color}) {
    removeColorFromSizeLo(size: size, color: color);
    notifyListeners();
  }

  // Food mixin setters

  void setSelectedFoodDrinkSubCategory(String value) {
    setSelectedFoodDrinkSubCategoryLo(value);
    notifyListeners();
  }

  // Pet mixin setters

  void setReadyToLeave(String? value) {
    setReadyToLeaveLo(value);
    notifyListeners();
  }

  void setPetCategory(String? category) {
    setPetCategoryLo(category);
    notifyListeners();
  }

  void setPetBreed(String? value) {
    setPetBreedLo(value);
    notifyListeners();
  }

  void setVaccinationUpToDate(bool? value) {
    setVaccinationUpToDateLo(value);
    notifyListeners();
  }

  void setWormFleaTreated(bool? value) {
    setWormFleaTreatedLo(value);
    notifyListeners();
  }

  void setHealthChecked(bool? value) {
    setHealthCheckedLo(value);
    notifyListeners();
  }

  void setAge(String? value) {
    setAgeLo(value);
    notifyListeners();
  }

  void setGarden(bool? value) {
    setGardenLo(value);
    notifyListeners();
  }

  void setParking(bool? value) {
    setParkingLo(value);
    notifyListeners();
  }

  void setAnimalFriendly(bool? value) {
    setAnimalFriendlyLo(value);
    notifyListeners();
  }

  void setPropertyType(String? value) {
    setPropertyTypeLo(value);
    notifyListeners();
  }

  void setEnergyRating(String? value) {
    setEnergyRatingLo(value);
    notifyListeners();
  }

  void setSelectedTenureType(TenureType value) {
    setSelectedTenureTypeLo(value);
    notifyListeners();
  }

  void setSelectedPropertySubType(String? value) {
    setSelectedPropertySubTypeLo(value);
    notifyListeners();
  }

  void setTransmissionType(String? value) {
    setTransmissionTypeLo(value);
    notifyListeners();
  }

  void setFuelType(String? value) {
    setFuelTypeLo(value);
    notifyListeners();
  }

  void setMake(String? value) {
    setMakeLo(value);
    notifyListeners();
  }

  void setYear(String? value) {
    setYearLo(value);
    notifyListeners();
  }

  void setEmissionType(String? value) {
    setEmissionTypeLo(value);
    notifyListeners();
  }

  void setBodyType(String? type) {
    setBodyTypeLo(type);
    notifyListeners();
  }

  void setVehicleCategory(String? type) {
    setVehicleCategoryLo(type);
    notifyListeners();
  }

  void setMileageUnit(String? unit) {
    setMileageUnitLo(unit);
    notifyListeners();
  }

  void setVehicleColor(ColorOptionEntity? value) {
    setVehicleColorLo(value);
    notifyListeners();
  }

  void setInteriorColor(String? value) {
    setInteriorColorLo(value);
    notifyListeners();
  }

  void setExteriorColor(String? value) {
    setExteriorColorLo(value);
    notifyListeners();
  }

  // Availability delegation
  List<AvailabilityEntity> get availability =>
      _availabilityManager.availability;

  List<String> generateTimeSlots() => _availabilityManager.generateTimeSlots();

  void toggleOpen(DayType day, bool isOpen) {
    _availabilityManager.toggleOpen(day, isOpen);
    notifyListeners();
  }

  void setOpeningTime(DayType day, String time) {
    _availabilityManager.setOpeningTime(day, time);
    notifyListeners();
  }

  void setClosingTime(DayType day, String time) {
    _availabilityManager.setClosingTime(day, time);
    notifyListeners();
  }

  void updateOpeningTime(DayType day, String time) {
    _availabilityManager.updateOpeningTime(day, time);
    notifyListeners();
  }

  bool isClosingTimeValid(String openingTime, String closingTime) =>
      _availabilityManager.isClosingTimeValid(openingTime, closingTime);

  TimeOfDay parseTimeString(String timeString) =>
      _availabilityManager.parseTimeString(timeString);

  // State delegation - Getters
  ListingType get listingType => _state.listingType ?? ListingType.items;
  SubCategoryEntity? get selectedCategory => _state.selectedCategory;
  PostEntity? get post => _post;
  bool get isDiscounted => _state.isDiscounted;
  DiscountEntity? get discounts => _state.discounts;
  LocationEntity? get selectedMeetupLocation => _state.selectedMeetupLocation;
  LocationEntity? get selectedCollectionLocation =>
      _state.selectedCollectionLocation;
  LatLng? get meetupLatLng => _state.meetupLatLng;
  LatLng? get collectionLatLng => _state.collectionLatLng;
  List<PickedAttachment> get attachments => _attachmentManager.items;
  ConditionType get condition => _state.condition;
  bool get acceptOffer => _state.acceptOffer;
  PrivacyType get privacy => _state.privacy;
  DeliveryType get deliveryType => _state.deliveryType;
  DeliveryPayer get deliveryPayer => _state.deliveryPayer;
  bool get isLoading => _state.isLoading;
  String get accessCode => _state.accessCode;
  List<ListingEntity> get listings => _listings;

  // TextEditingController Getter
  TextEditingController get title => _state.title;
  TextEditingController get description => _state.description;

  TextEditingController get price => _state.price;
  TextEditingController get quantity => _state.quantity;
  TextEditingController get minimumOffer => _state.minimumOffer;
  TextEditingController get engineSize => _state.engineSize;
  TextEditingController get mileage => _state.mileage;
  TextEditingController get model => _state.model;
  TextEditingController get doors => _state.doors;
  TextEditingController get seats => _state.seats;
  TextEditingController get location => _state.location;
  TextEditingController get packageHeight => _state.packageHeight;
  TextEditingController get packageWidth => _state.packageWidth;
  TextEditingController get packageLength => _state.packageLength;
  TextEditingController get packageWeight => _state.packageWeight;
  TextEditingController get bedroom => _state.bedroom;
  TextEditingController get bathroom => _state.bathroom;
  // State delegation - Setters
  void startediting(PostEntity value) {
    _post = value;
    initializeForEdit(value);
    AppLog.info('Editing post initialized — ID: ${value.postID}');
    AppNavigator.pushNamed(AddListingFormScreen.routeName);
  }

  void setListingType(ListingType? value) {
    _state.listingType = value;
  }

  void setSelectedCategory(SubCategoryEntity? value) {
    if (value == null) return;
    _state.selectedCategory = value;
  }

  void setIsDiscount(bool value) {
    _state.isDiscounted = value;
    notifyListeners();
  }

  void setDiscounts(DiscountEntity? value) {
    _state.discounts = value;
    notifyListeners();
  }

  void setCondition(ConditionType value) {
    _state.condition = value;
    notifyListeners();
  }

  void setAcceptOffer(bool value) {
    _state.acceptOffer = value;
    notifyListeners();
  }

  void setPrivacy(PrivacyType value) {
    _state.privacy = value;
    notifyListeners();
  }

  void setDeliveryType(DeliveryType? value) {
    if (value == null || _state.deliveryType == value) return;
    _state.deliveryType = value;
    notifyListeners();
  }

  void setDeliveryPayer(DeliveryPayer? value) {
    if (value == null) return;
    _state.deliveryPayer = value;
    if (value == DeliveryPayer.sellerPays) {
      _state.deliveryType = DeliveryType.freeDelivery;
    } else if (value == DeliveryPayer.buyerPays) {
      _state.deliveryType = DeliveryType.paid;
    }
    notifyListeners();
  }

  void setCollectionLocation(LocationEntity location, LatLng latlng) {
    _state.selectedCollectionLocation = location;
    _state.collectionLatLng = latlng;
    notifyListeners();
  }

  void setMeetupLocation(LocationEntity value, LatLng latlng) {
    _state.selectedMeetupLocation = value;
    _state.meetupLatLng = latlng;
    notifyListeners();
  }

  void setAccessCode(String? value) {
    if (value == null) return;
    _state.accessCode = value;
  }

  void setLoading(bool value) {
    _state.isLoading = value;
  }

  // Core methods
  Future<void> reset() async {
    _state.isLoading = false;
    _state.reset();
    _availabilityManager.reset();
    _attachmentManager.clear();
    _post = null;
    _listings.clear();
    // Reset property-specific mixin state to defaults via available setters
    setGarden(true);
    setParking(true);
    setAnimalFriendly(true);
    setSelectedTenureType(TenureType.freehold);
    setPropertyType(null);
    setEnergyRating(null);
    setSelectedPropertySubType(ListingType.property.cids.first);
  }

  Future<void> submit(BuildContext context) async {
    final (bool isValid, String? error) = await validateForm(context);
    if (!isValid) {
      if (error != null) {
        AppSnackBar.errorGlobal(error);
      }
      return;
    }
    setLoading(true);
    try {
      switch (listingType) {
        case ListingType.items:
          await _onItemSubmit();
          break;
        case ListingType.clothAndFoot:
          await _onClothesAndFootSubmit();
          break;
        case ListingType.vehicle:
          await _onVehicleSubmit();
          break;
        case ListingType.foodAndDrink:
          await _onFoodAndDrinkSubmit();
          break;
        case ListingType.property:
          await _onPropertySubmit();
          break;
        case ListingType.pets:
          await _onPetSubmit();
          break;
      }
    } catch (e, st) {
      AppLog.error('Error during submission: $e\n$st');
      AppSnackBar.errorGlobal('submission_error'.tr());
    } finally {
      setLoading(false);
    }
  }

  // ---- Helpers: attachments ----
  int _totalOf(AttachmentType type) =>
      _attachmentManager.totalOf(_post?.fileUrls, type);

  bool get hasAtLeastOnePhoto => _totalOf(AttachmentType.image) >= 1;
  bool get hasAtLeastOneVideo => _totalOf(AttachmentType.video) >= 1;

  int get totalPhotos => _totalOf(AttachmentType.image);

  /// Single validation function that checks all aspects of the form
  /// Returns a tuple (bool, String?) where bool indicates validity and String contains any error message
  Future<(bool, String?)> validateForm(BuildContext context) async {
    if (listingType == ListingType.items ||
        listingType == ListingType.clothAndFoot ||
        listingType == ListingType.foodAndDrink) {
      if (selectedCategory == null) {
        return (false, 'choose_category'.tr());
      }
      if (deliveryType == DeliveryType.paid ||
          deliveryType == DeliveryType.freeDelivery) {
        bool hasValidParcelDetails() {
          String norm(String s) => s.trim().replaceAll(',', '.');
          double? toNum(String s) => double.tryParse(norm(s));

          final double? l = toNum(_state.packageLength.text);
          final double? w = toNum(_state.packageWidth.text);
          final double? h = toNum(_state.packageHeight.text);

          return l != null && l > 0 && w != null && w > 0 && h != null && h > 0;
        }

        if (!hasValidParcelDetails()) {
          return (false, 'please_fill_parcel_size'.tr());
        }
      }
    }

    if (!hasAtLeastOnePhoto) {
      return (false, 'please_add_at_least_one_photo'.tr());
    }

    final bool isValid = switch (listingType) {
      ListingType.vehicle => vehicleKey.currentState?.validate() ?? false,
      ListingType.clothAndFoot =>
        clothesAndFootKey.currentState?.validate() ?? false,
      ListingType.foodAndDrink =>
        foodAndDrinkKey.currentState?.validate() ?? false,
      ListingType.property => propertyKey.currentState?.validate() ?? false,
      ListingType.pets => petKey.currentState?.validate() ?? false,
      ListingType.items => itemKey.currentState?.validate() ?? false,
    };

    if (!isValid) {
      return (false, null);
    }

    return (true, null);
  }

  // Submission methods
  Future<void> _submitCommon(AddListingParam param) async {
    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);
    _handleSubmissionResult(result);
  }

  Future<void> _onItemSubmit() async {
    final AddListingParam param = AddListingParam(
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      isDiscounted: isDiscounted,
      discount: isDiscounted ? state.discounts : null,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      packageDetail:
          deliveryType != DeliveryType.collection ? pkgDetails : null,
      collectionLocation: selectedCollectionLocation,
      meetUpLocation: selectedMeetupLocation,
    );

    await _submitCommon(param);
  }

  Future<void> _onClothesAndFootSubmit() async {
    final String address = _resolveAddress(category: selectedCategory);

    final PostClothFootEntity clothParams = PostClothFootEntity(
      type: _state.clothSubCategory,
      address: address,
      sizeColors: _state.sizeColorEntities,
      sizeChartUrl: null,
      brand: _state.brand ?? '',
    );
    final AddListingParam param = AddListingParam(
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      isDiscounted: isDiscounted,
      discount: isDiscounted ? state.discounts : null,
      clothfootParams: clothParams,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      packageDetail:
          deliveryType != DeliveryType.collection ? pkgDetails : null,
      collectionLocation: selectedCollectionLocation,
      meetUpLocation: selectedMeetupLocation,
      type: _state.clothSubCategory,
    );

    await _submitCommon(param);
  }

  Future<void> _onFoodAndDrinkSubmit() async {
    final String address = selectedCategory?.address ?? '';
    final PostFoodDrinkEntity foodDrinkParams = PostFoodDrinkEntity(
      type: _state.foodDrinkSubCategory,
      address: address,
    );
    final AddListingParam param = AddListingParam(
      type: selectedFoodDrinkSubCategory,
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      isDiscounted: isDiscounted,
      discount: isDiscounted ? discounts : null,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      foodDrinkParams: foodDrinkParams,
      packageDetail:
          deliveryType != DeliveryType.collection ? pkgDetails : null,
      collectionLocation: selectedCollectionLocation,
      meetUpLocation: selectedMeetupLocation,
      address: address,
    );

    await _submitCommon(param);
  }

  Future<void> _onVehicleSubmit() async {
    final String address = _resolveAddress(
      category: selectedCategory,
      vehiclesCategory: _state.vehicleCategory,
      bodyType: _state.bodyType,
    );

    final PostVehicleEntity vehicleParams = PostVehicleEntity(
      address: address,
      year: int.tryParse(_state.year ?? '') ?? 0,
      doors: int.tryParse(doors.text) ?? 0,
      seats: int.tryParse(seats.text) ?? 0,
      mileage: int.tryParse(mileage.text) ?? 0,
      make: _state.make ?? '',
      model: model.text,
      bodyType: _state.bodyType ?? '',
      emission: _state.emission ?? '',
      fuelType: _state.fuelType ?? '',
      engineSize: double.tryParse(engineSize.text) ?? 0.0,
      mileageUnit: _state.mileageUnit ?? '',
      transmission: _state.transmissionType ?? '',
      interiorColor: _state.interiorColor ?? '',
      exteriorColor: _state.exteriorColor ?? '',
      vehiclesCategory: _state.vehicleCategory ?? '',
    );

    final AddListingParam param = AddListingParam(
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      vehicleParams: vehicleParams,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      meetUpLocation: selectedMeetupLocation,
      availbility: _availabilityManager.getAvailabilityData(),
      address: address,
    );

    await _submitCommon(param);
  }

  Future<void> _onPetSubmit() async {
    final String address = _resolveAddress(
      category: selectedCategory,
      petsCategory: _state.petCategory,
      breed: _state.breed,
    );

    final PostPetEntity petParams = PostPetEntity(
      address: address,
      age: _state.age,
      breed: _state.breed,
      healthChecked: _state.healthChecked,
      petsCategory: _state.petCategory,
      readyToLeave: _state.readyToLeave,
      vaccinationUpToDate: _state.vaccinationUpToDate,
      wormAndFleaTreated: _state.wormAndFleaTreated,
    );

    final AddListingParam param = AddListingParam(
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      petsParams: petParams,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      meetUpLocation: selectedMeetupLocation,
      availbility: _availabilityManager.getAvailabilityData(),
      address: address,
    );
    await _submitCommon(param);
  }

  Future<void> _onPropertySubmit() async {
    final AddListingParam param = AddListingParam(
      currency: LocalAuth.currency,
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachmentManager.items,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      propertyParams: PostPropertyEntity(
        address: '',
        bedroom: _state.parsedBedroom ?? 0,
        bathroom: _state.parsedBathroom ?? 0,
        energyRating: _state.energyRating ?? '',
        propertyType: _state.propertyType ?? '',
        propertyCategory: _state.propertySubCategory,
        garden: _state.hasGarden,
        parking: _state.hasParking,
        tenureType: _state.tenureType.value,
      ),
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      meetUpLocation: selectedMeetupLocation,
      availbility: _availabilityManager.getAvailabilityData(),
    );

    await _submitCommon(param);
  }

  String _resolveAddress({
    SubCategoryEntity? category,
    String? vehiclesCategory,
    String? bodyType,
    String? petsCategory,
    String? breed,
    String? propertyType,
  }) {
    if (listingType == ListingType.vehicle) {
      return '${listingType.json}/${vehiclesCategory ?? ''}/${bodyType ?? ''}';
    }

    if (listingType == ListingType.pets) {
      return '${listingType.json}/${petsCategory ?? ''}/${breed ?? ''}';
    }

    if (listingType == ListingType.property) {
      return '${listingType.json}/${propertyType ?? ''}';
    }
    return category?.address ?? '';
  }

  void _handleSubmissionResult(DataState<String> result) {
    if (result is DataSuccess) {
      final String successKey = _post == null
          ? 'listing_posted_successfully'
          : 'listing_updated_successfully';
      AppSnackBar.successGlobal(successKey.tr());
      AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName, (_) => false);
      reset();
    } else if (result is DataFailer) {
      final String msg = result.exception?.message ?? 'something_wrong'.tr();
      AppSnackBar.errorGlobal(msg);
      AppLog.error(msg);
    } else {
      AppSnackBar.errorGlobal('something_wrong'.tr());
      AppLog.error('Unknown submission result state');
    }
  }

  // Attachment methods
  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    await _attachmentManager.pick(
      context,
      type: type,
      listingType: listingType,
    );
  }

  void addAttachment(PickedAttachment attachment) {
    _attachmentManager.add(attachment);
  }

  void removePickedAttachment(PickedAttachment attachment) {
    _attachmentManager.remove(attachment);
  }

  void removeAttachmentEntity(AttachmentEntity attachment) {
    _post?.fileUrls.remove(attachment);
  }

  // Utility methods
  void incrementQuantity() {
    final int value = int.tryParse(_state.quantity.text) ?? 1;
    _state.quantity.text = (value + 1).toString();
  }

  void decrementQuantity() {
    final int value = int.tryParse(_state.quantity.text) ?? 1;
    if (value > 1) {
      _state.quantity.text = (value - 1).toString();
    }
  }

  void initializeForEdit(PostEntity post) {
    reset();
    _post = post;
    title.text = post.title;
    description.text = post.description;
    price.text = post.price.toString();
    quantity.text = post.quantity.toString();
    minimumOffer.text = post.minOfferAmount.toString();
    setIsDiscount(post.hasDiscount);
    // _state.discounts = post.discounts;

    final DeliveryPayer payer = post.deliveryType == DeliveryType.paid
        ? DeliveryPayer.buyerPays
        : DeliveryPayer.sellerPays;
    setDeliveryPayer(payer);
    try {
      _state.listingType = ListingType.fromJson(post.listID);
    } catch (_) {
      _state.listingType = ListingType.items;
    }
    _state.condition = post.condition;
    _state.acceptOffer = post.acceptOffers;
    debugPrint('discount post ${post.discount.toString()}');
    setDiscounts(post.discount);
    setIsDiscount(post.hasDiscount);
    _state.privacy = post.privacy;
    _state.accessCode = post.accessCode ?? '';
    _state.engineSize.text = post.vehicleInfo?.engineSize?.toString() ?? '';
    _state.mileage.text = post.vehicleInfo?.mileage?.toString() ?? '';
    _state.model.text = post.vehicleInfo?.model?.toString() ?? '';
    _state.doors.text = post.vehicleInfo?.doors?.toString() ?? '';
    _state.seats.text = post.vehicleInfo?.seats?.toString() ?? '';
    _state.location.text = post.meetUpLocation?.address?.toString() ?? '';
    _state.bedroom.text = post.propertyInfo?.bedroom?.toString() ?? '';
    _state.bathroom.text = post.propertyInfo?.bathroom?.toString() ?? '';
    if (post.meetUpLocation != null) {
      _state.selectedMeetupLocation = post.meetUpLocation;
      _state.meetupLatLng = LatLng(
        (post.meetUpLocation?.latitude ?? 0).toDouble(),
        (post.meetUpLocation?.longitude ?? 0).toDouble(),
      );
    }

    if (post.collectionLocation != null) {
      _state.selectedCollectionLocation = post.collectionLocation;
      _state.collectionLatLng = LatLng(
        (post.collectionLocation?.latitude ?? 0).toDouble(),
        (post.collectionLocation?.longitude ?? 0).toDouble(),
      );
    }

    _state.deliveryType = post.deliveryType;

    _state.packageHeight.text = post.packageDetail.height.toString();
    _state.packageWidth.text = post.packageDetail.width.toString();
    _state.packageLength.text = post.packageDetail.length.toString();
    _state.packageWeight.text = post.packageDetail.weight.toString();

    if (post.availability != null) {
      _availabilityManager.setAvailabilty(post.availability!);
    }

    // Initialize mixin-specific data from post
    if (post.vehicleInfo != null) {
      initializeVehicleFromPost(post.vehicleInfo!);
    }
    if (post.propertyInfo != null) {
      initializePropertyFromPost(post.propertyInfo!);
    }
    if (post.petInfo != null) {
      initializePetFromPost(post.petInfo!);
    }
    if (post.clothFootInfo != null) {
      initializeClothFromPost(post.clothFootInfo!);
    }
    if (post.foodDrinkInfo != null) {
      initializeFoodDrinkFromPost(post.foodDrinkInfo!);
    }
    if (post.itemInfo != null) {
      initializeItemFromPost(post.itemInfo!);
    }
    AppLog.info('Editing post initialized — ID: ${post.postID}');
  }

  // Helper methods to initialize mixin data from post
  void initializeVehicleFromPost(PostVehicleEntity vehicleInfo) {
    state.make = vehicleInfo.make;
    state.transmissionType = vehicleInfo.transmission;
    state.fuelType = vehicleInfo.fuelType;
    state.bodyType = vehicleInfo.bodyType;
    state.vehicleCategory = vehicleInfo.vehiclesCategory;
    state.mileageUnit = vehicleInfo.mileageUnit;
    state.year = vehicleInfo.year?.toString();
    state.emission = vehicleInfo.emission;
    state.interiorColor = vehicleInfo.interiorColor;
    state.exteriorColor = vehicleInfo.exteriorColor;
    if ((vehicleInfo.exteriorColor ?? '').isNotEmpty) {
      state.vehicleColor = ColorOptionEntity(
        label: vehicleInfo.exteriorColor!,
        value: vehicleInfo.exteriorColor!,
        shade: '',
        tag: <String>[],
      );
    } else {
      state.vehicleColor = null;
    }
  }

  void initializePropertyFromPost(PostPropertyEntity propertyInfo) {
    setGarden(propertyInfo.garden);
    setParking(propertyInfo.parking);
    setPropertyType(propertyInfo.propertyType);
    setEnergyRating(propertyInfo.energyRating);
    setSelectedPropertySubType(propertyInfo.propertyCategory);
    final String? tenure = propertyInfo.tenureType;
    if (tenure != null && tenure.isNotEmpty) {
      try {
        setSelectedTenureType(TenureTypeExtension.fromJson(tenure));
      } catch (_) {
        setSelectedTenureType(TenureType.freehold);
      }
    }
  }

  void initializePetFromPost(PostPetEntity petInfo) {
    setAge(petInfo.age);
    setPetBreed(petInfo.breed);
    setHealthChecked(petInfo.healthChecked ?? false);
    setPetCategory(petInfo.petsCategory);
    setReadyToLeave(petInfo.readyToLeave);
    setVaccinationUpToDate(petInfo.vaccinationUpToDate ?? false);
    setWormFleaTreated(petInfo.wormAndFleaTreated ?? false);
  }

  void initializeClothFromPost(PostClothFootEntity clothInfo) {
    _state.selectedCategory = LocalCategoriesSource()
        .findSubCategoryByAddress(post?.clothFootInfo?.address ?? '');
    setBrand(clothInfo.brand);
    setSelectedClothSubCategory(clothInfo.type);
    _state.sizeColorEntities
      ..clear()
      ..addAll(_cloneSizeColors(clothInfo.sizeColors));
    setSelectedCategory(
        LocalCategoriesSource().findSubCategoryByAddress(clothInfo.address));
  }

  void initializeFoodDrinkFromPost(PostFoodDrinkEntity foodDrinkInfo) {
    setSelectedFoodDrinkSubCategory(foodDrinkInfo.type);
    _state.selectedCategory = LocalCategoriesSource()
        .findSubCategoryByAddress(post?.foodDrinkInfo?.address ?? '');
  }

  void initializeItemFromPost(PostItemEntity itemInfo) {
    _state.selectedCategory = LocalCategoriesSource()
        .findSubCategoryByAddress(post?.itemInfo?.address ?? '');
  }

  List<SizeColorEntity> _cloneSizeColors(List<SizeColorEntity> source) {
    return source
        .map(
          (SizeColorEntity e) => SizeColorModel(
            value: e.value,
            id: e.id,
            colors: e.colors
                .map(
                  (ColorEntity c) =>
                      ColorEntity(code: c.code, quantity: c.quantity),
                )
                .toList(),
          ),
        )
        .toList();
  }

  /// Navigate to preview screen after validating form. For edit, uses existing post.
  Future<void> getPreview(BuildContext context) async {
    final (bool isValid, String? error) = await validateForm(context);
    if (!isValid) {
      if (error != null) {
        AppSnackBar.errorGlobal(error);
      }
      return;
    }

    if (_post != null) {
      await Navigator.push(
        context,
        MaterialPageRoute<AddListingPreviewScreen>(
          builder: (BuildContext context) => AddListingPreviewScreen(
            pickedAttachments: attachments,
            post: _post!,
          ),
        ),
      );
      return;
    }

    try {
      final PackageDetailEntity previewPackageDetail = pkgDetails ??
          PackageDetailEntity(length: 0, width: 0, weight: 0, height: 0);

      final PostClothFootEntity previewClothInfo =
          listingType == ListingType.clothAndFoot
              ? PostClothFootEntity(
                  type: _state.clothSubCategory,
                  address: '',
                  sizeColors: _cloneSizeColors(_state.sizeColorEntities),
                  sizeChartUrl: null,
                  brand: _state.brand ?? '',
                )
              : PostClothFootEntity(
                  type: _state.foodDrinkSubCategory,
                  address: '',
                  sizeColors: <SizeColorEntity>[],
                  sizeChartUrl: null,
                  brand: null,
                );

      final PostPropertyEntity? previewPropertyInfo =
          listingType == ListingType.property
              ? PostPropertyEntity(
                  address: '',
                  bedroom: _state.parsedBedroom ?? 0,
                  bathroom: _state.parsedBathroom ?? 0,
                  energyRating: _state.energyRating ?? '',
                  propertyType: _state.propertyType ?? '',
                  propertyCategory: _state.propertySubCategory,
                  garden: _state.hasGarden,
                  parking: _state.hasParking,
                  tenureType: _state.tenureType.value,
                )
              : null;

      final PostPetEntity? previewPetInfo = listingType == ListingType.pets
          ? PostPetEntity(
              address: '',
              age: _state.age,
              breed: _state.breed,
              healthChecked: _state.healthChecked,
              petsCategory: _state.petCategory,
              readyToLeave: _state.readyToLeave,
              vaccinationUpToDate: _state.vaccinationUpToDate,
              wormAndFleaTreated: _state.wormAndFleaTreated,
            )
          : null;
      final PostFoodDrinkEntity? previewFoodDrinkInfo =
          listingType == ListingType.foodAndDrink
              ? PostFoodDrinkEntity(
                  address: '',
                  type: _state.foodDrinkSubCategory,
                )
              : null;
      final PostItemEntity? previewItemInfo = listingType == ListingType.items
          ? PostItemEntity(
              address: '',
            )
          : null;
      final PostVehicleEntity? previewVehicleInfo =
          listingType == ListingType.vehicle
              ? PostVehicleEntity(
                  address: '',
                  year: int.tryParse(_state.year ?? '') ?? 0,
                  doors: int.tryParse(doors.text) ?? 0,
                  seats: int.tryParse(seats.text) ?? 0,
                  mileage: int.tryParse(mileage.text) ?? 0,
                  make: _state.make ?? '',
                  model: model.text,
                  bodyType: _state.bodyType ?? '',
                  emission: _state.emission ?? '',
                  fuelType: _state.fuelType ?? '',
                  engineSize: double.tryParse(engineSize.text) ?? 0.0,
                  mileageUnit: _state.mileageUnit ?? '',
                  transmission: _state.transmissionType ?? '',
                  interiorColor: _state.interiorColor ?? '',
                  exteriorColor: _state.exteriorColor,
                  vehiclesCategory: _state.vehicleCategory ?? '',
                )
              : null;
      final PostEntity previewPost = PostEntity(
        listID: listingType.json,
        postID: 'preview_${DateTime.now().millisecondsSinceEpoch}',
        businessID: null,
        title: title.text,
        description: description.text,
        price: double.tryParse(price.text) ?? 0.0,
        quantity: int.tryParse(quantity.text) ?? 1,
        currency: LocalAuth.currency,
        type: listingType,
        acceptOffers: acceptOffer,
        minOfferAmount: double.tryParse(minimumOffer.text) ?? 0.0,
        privacy: privacy,
        condition: condition,
        listOfReviews: <double>[],
        categoryType: selectedCategory?.title ?? '',
        currentLongitude: LocalAuth.latlng.longitude,
        currentLatitude: LocalAuth.latlng.latitude,
        collectionLatitude: selectedCollectionLocation?.latitude,
        collectionLongitude: selectedCollectionLocation?.longitude,
        collectionLocation: selectedCollectionLocation,
        meetUpLocation: selectedMeetupLocation,
        deliveryType: deliveryType,
        localDelivery: 1,
        internationalDelivery: null,
        availability: availability.isNotEmpty ? availability : null,
        fileUrls: <AttachmentEntity>[],
        hasDiscount: isDiscounted,
        discount: discounts,
        clothFootInfo: previewClothInfo,
        propertyInfo: previewPropertyInfo,
        petInfo: previewPetInfo,
        vehicleInfo: previewVehicleInfo,
        foodDrinkInfo: previewFoodDrinkInfo,
        itemInfo: previewItemInfo,
        packageDetail: previewPackageDetail,
        isActive: true,
        createdBy: LocalAuth.uid ?? 'null',
        updatedBy: LocalAuth.uid ?? 'null',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        accessCode: accessCode,
      );

      await Navigator.push(
        context,
        MaterialPageRoute<AddListingPreviewScreen>(
          builder: (BuildContext context) => AddListingPreviewScreen(
            pickedAttachments: attachments,
            post: previewPost,
          ),
        ),
      );
    } catch (e, st) {
      AppLog.error('Error_generating_preview: $e\n$st');
      AppSnackBar.errorGlobal('preview_error'.tr());
    }
  }

  DropdownOptionEntity? findByValue(
      List<DropdownOptionEntity> list, String valueToFind) {
    AppLog.info(
        'findByValue called with valueToFind: $valueToFind, list length: ${list.length}');
    try {
      for (final DropdownOptionEntity option in list) {
        AppLog.info(
            'Checking option: value=${option.value.value}, label=${option.value.label}');
      }
      final DropdownOptionEntity result = list.firstWhere(
        (DropdownOptionEntity option) {
          final bool match = option.value.value == valueToFind;
          if (match) {
            AppLog.info(
                'Match found: value=${option.value.value}, label=${option.value.label}');
          }
          return match;
        },
      );
      AppLog.info(
          'findByValue returning: value=${result.value.value}, label=${result.value.label}');
      // Do NOT call notifyListeners() here! This method is a synchronous lookup and may be called during build.
      // If you need to update the UI, call notifyListeners() from the caller after updating state.
      return result;
    } catch (e, st) {
      AppLog.error('findByValue error: $e', stackTrace: st);
      // Do NOT call notifyListeners() here! See above.
      return null;
    }
  }
}


// class AddListingFormProvider extends ChangeNotifier {
//   AddListingFormProvider(
//     this._addlistingUSecase,
//     this._editListingUsecase,
//     this._getCategoriesByEndPoint,
//   );
//   final AddListingUsecase _addlistingUSecase;
//   final EditListingUsecase _editListingUsecase;
//   final GetCategoryByEndpointUsecase _getCategoriesByEndPoint;

//   List<AvailabilityEntity> _availability = DayType.values.map((DayType day) {
//     return AvailabilityModel(
//       day: day,
//       isOpen: false,
//       openingTime: '',
//       closingTime: '',
//     );
//   }).toList();

//   // Getter for availability list.
//   List<AvailabilityEntity> get availability => _availability;
//   // Toggle open status and update default times.
//   void toggleOpen(DayType day, bool isOpen) {
//     final int index =
//         _availability.indexWhere((AvailabilityEntity e) => e.day == day);
//     if (index != -1) {
//       final AvailabilityEntity current = _availability[index];
//       _availability[index] = current.copyWith(
//         isOpen: isOpen,
//         openingTime: isOpen ? '10:00 am' : '',
//         closingTime: isOpen ? '10:00 pm' : '',
//       );
//       notifyListeners();
//     }
//   }

//   // Set a new opening time.
//   void setOpeningTime(DayType day, String time) {
//     final int index =
//         _availability.indexWhere((AvailabilityEntity e) => e.day == day);
//     if (index != -1) {
//       final AvailabilityEntity current = _availability[index];
//       _availability[index] = current.copyWith(openingTime: time);
//       notifyListeners();
//     }
//   }

//   // Set a new closing time.
//   void setClosingTime(DayType day, String time) {
//     final int index =
//         _availability.indexWhere((AvailabilityEntity e) => e.day == day);
//     if (index != -1) {
//       final AvailabilityEntity current = _availability[index];
//       _availability[index] = current.copyWith(closingTime: time);
//       notifyListeners();
//     }
//   }

//   // Generate time slots in 30-minute increments.
//   List<String> generateTimeSlots() {
//     final List<String> slots = <String>[];
//     for (int hour = 0; hour < 24; hour++) {
//       for (int minute = 0; minute < 60; minute += 30) {
//         final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
//         slots.add(_formatTimeOfDay(time));
//       }
//     }
//     return slots;
//   }

//   // Format TimeOfDay into a string like "10:00 am".
//   String _formatTimeOfDay(TimeOfDay time) {
//     final int hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final String minute = time.minute.toString().padLeft(2, '0');
//     final String period = time.period == DayPeriod.am ? 'am' : 'pm';
//     return '$hourOfPeriod:$minute $period';
//   }

//   // Parse a time string like "10:00 am" into TimeOfDay.
//   TimeOfDay parseTimeString(String timeString) {
//     try {
//       final List<String> parts = timeString.split(RegExp(r'[: ]'));
//       final int hour = int.parse(parts[0]) +
//           ((parts[2].toLowerCase() == 'pm' && parts[0] != '12') ? 12 : 0);
//       final int minute = int.parse(parts[1]);
//       return TimeOfDay(hour: hour, minute: minute);
//     } catch (_) {
//       return const TimeOfDay(hour: 9, minute: 0);
//     }
//   }

//   // Validate that closing time is later than opening time.
//   bool isClosingTimeValid(String openingTime, String closingTime) {
//     final TimeOfDay open = parseTimeString(openingTime);
//     final TimeOfDay close = parseTimeString(closingTime);
//     return ((close.hour * 60 + close.minute) > (open.hour * 60 + open.minute));
//   }

//   // Update opening time and auto-adjust closing time if necessary.
//   void updateOpeningTime(DayType day, String time) {
//     setOpeningTime(day, time);
//     // Get the current entity for the day.
//     final AvailabilityEntity entity =
//         availability.firstWhere((AvailabilityEntity e) => e.day == day);
//     // If closing time is empty or not valid, adjust closing time automatically.
//     if (entity.closingTime.isEmpty ||
//         !isClosingTimeValid(time, entity.closingTime)) {
//       final TimeOfDay parsedTime = parseTimeString(time);
//       final TimeOfDay endTime = parsedTime.replacing(hour: parsedTime.hour + 1);
//       setClosingTime(day, _formatTimeOfDay(endTime));
//     }
//   }

// // Prepare the availability data for the API
//   List<Map<String, dynamic>>? availabilityData;
//   // This method will generate the availability data from your _availability list
//   List<Map<String, dynamic>> getAvailabilityData() {
//     return _availability
//         .map((AvailabilityEntity model) => model.toJson())
//         .toList();
//   }

//   Future<void> reset() async {
//     // Text fields
//     _title.clear();
//     _description.clear();
//     _price.clear();
//     _quantity.text = '1';
//     _minimumOffer.clear();
//     _engineSize.clear();
//     _mileage.clear();
//     _bedroom.clear();
//     _bathroom.clear();
//     _model.clear();
//     _seats.clear();
//     _doors.clear();
//     _emission = null;
//     _location.clear();
//     // File attachments
//     _attachments = <PickedAttachment>[];
//     // Core post data
//     _post = null;
//     _accessCode = '';
//     _isDiscounted = false;
//     // Booleans
//     _garden = true;
//     _parking = true;
//     _animalFriendly = true;
//     _acceptOffer = true;
//     // Enums and types
//     _age = null;
//     _time = null;
//     _condition = ConditionType.newC;
//     _privacy = PrivacyType.public;
//     _deliveryType = DeliveryType.paid;
//     _listingType = null;
//     _transmissionType = null;
//     _make = null;
//     // Nullable booleans
//     _vaccinationUpToDate = null;
//     _wormAndFleaTreated = null;
//     _healthChecked = null;
//     // Categories and selections
//     _brand = null;
//     _selectedCategory = null;
//     _breed = null;
//     _petCategory = null;
//     _selectedBodyType = null;
//     _selectedEnergyRating = null;
//     _selectedMileageUnit = null;
//     _selectedPropertyType = null;
//     _selectedVehicleCategory = null;
//     _selectedVehicleColor = null;
//     _selectedMeetupLocation = null;
//     _selectedCollectionLocation = null;
//     _meetupLatLng = null;
//     _collectionLatLng = null;
//     // List data
//     _sizeColorEntities = <SizeColorModel>[];
//     // Strings
//     _tenureType = 'freehold';
//     _selectedPropertySubCategory = ListingType.property.cids.first;
//     _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;

//     // Reset discounts
//     for (DiscountEntity element in _discounts) {
//       element.discount = 0;
//     }

//     // Reset form keys
//     _petKey.currentState?.reset();
//     _itemKey.currentState?.reset();
//     _vehicleKey.currentState?.reset();
//     _propertyKey.currentState?.reset();
//     _foodAndDrinkKey.currentState?.reset();
//     _clothesAndFootKey.currentState?.reset();

//     debugPrint('listing variables reset');

//     notifyListeners();
//   }

//   Future<void> updateVariables() async {
//     if (post == null) return;
//     // -------------------------
//     // Category and accessCode
//     // -------------------------
//     _selectedCategory = LocalListing().getSubCategoryByAddress(post!.address);
//     _accessCode = post?.accessCode ?? '';
//     // -------------------------
//     // Pet-related fields
//     // -------------------------
//     _age = post?.petInfo?.age;
//     _animalFriendly = false;
//     _vaccinationUpToDate = post?.petInfo?.vaccinationUpToDate;
//     _wormAndFleaTreated = post?.petInfo?.wormAndFleaTreated;
//     _healthChecked = post?.petInfo?.healthChecked;
//     _time = post?.petInfo?.readyToLeave;
//     // -------------------------
//     // Availability
//     // -------------------------
//     _availability = post?.availability ?? <AvailabilityEntity>[];

//     // -------------------------
//     // Locations
//     // -------------------------
//     _selectedMeetupLocation = post?.meetUpLocation;
//     _selectedCollectionLocation = post?.collectionLocation;
//     _location.text = post?.meetUpLocation?.address ?? '';

//     // -------------------------
//     // Property details
//     // -------------------------
//     _bathroom.text = post?.propertyInfo?.bathroom?.toString() ?? '0';
//     _bedroom.text = post?.propertyInfo?.bedroom?.toString() ?? '0';
//     _garden = post?.propertyInfo?.garden ?? true;
//     _parking = post?.propertyInfo?.parking ?? true;
//     _selectedPropertySubCategory = post?.propertyInfo?.propertyCategory ?? '';
//     _selectedPropertyType = post?.propertyInfo?.propertyType;
//     _tenureType = post?.propertyInfo?.tenureType ?? '';

//     // -------------------------
//     // Product details
//     // -------------------------
//     _title.text = post?.title ?? '';
//     _description.text = post?.description ?? '';
//     _price.text = post?.price.toString() ?? '';
//     _quantity.text = post?.quantity.toString() ?? '1';
//     _minimumOffer.text = post?.minOfferAmount.toString() ?? '';
//     _isDiscounted = post?.hasDiscount ?? false;

//     // -------------------------
//     // Cloth-related fields
//     // -------------------------
//     _brand = post?.clothFootInfo.brand ?? '';
//     _selectedClothSubCategory = post?.categoryType ?? '';
//     _sizeColorEntities = post?.clothFootInfo.sizeColors ?? <SizeColorEntity>[];

//     // -------------------------
//     // Vehicle details
//     // -------------------------
//     _make = post?.vehicleInfo?.make ?? '';
//     _model.text = post?.vehicleInfo?.model ?? '';
//     _engineSize.text = post?.vehicleInfo?.engineSize?.toString() ?? '';
//     _mileage.text = post?.vehicleInfo?.mileage?.toString() ?? '';
//     _selectedMileageUnit = post?.vehicleInfo?.mileageUnit;
//     _emission = post?.vehicleInfo?.emission ?? '';
//     _seats.text = post?.vehicleInfo?.seats?.toString() ?? '';
//     _doors.text = post?.vehicleInfo?.doors?.toString() ?? '';
//     _year = post?.vehicleInfo?.year?.toString() ?? '';
//     _transmissionType = post?.vehicleInfo?.transmission ?? '';
//     _selectedVehicleCategory = post?.vehicleInfo?.vehiclesCategory;
//     _selectedVehicleColor =
//         LocalColors().getColor(post?.vehicleInfo?.exteriorColor ?? '');
//     _selectedBodyType = post?.vehicleInfo?.bodyType ?? '';
//     _selectedEnergyRating = post?.propertyInfo?.energyRating ?? '';

//     // -------------------------
//     // Delivery & fees
//     // -------------------------
//     _deliveryType = post?.deliveryType ?? DeliveryType.paid;

//     // -------------------------
//     // Listing, privacy, and condition
//     // -------------------------
//     _listingType = ListingType.fromJson(post?.listID);
//     _privacy = post?.privacy ?? PrivacyType.supporters;
//     _condition = post?.condition ?? ConditionType.newC;

//     // -------------------------
//     // Discounts
//     // -------------------------
//     debugPrint(post?.discounts.toString());
//     for (DiscountEntity element in _discounts) {
//       final DiscountEntity? matching = post?.discounts.firstWhere(
//         (DiscountEntity e) => e.quantity == element.quantity,
//         orElse: () => DiscountEntity(quantity: element.quantity, discount: 5),
//       );
//       element.discount = matching?.discount ?? 0;
//     }
//     debugPrint('listing variables updated successfully');
//   }

//   Future<void> submit(BuildContext context) async {
//     final int imageCount = _attachments
//             .where((PickedAttachment a) => a.type == AttachmentType.image)
//             .length +
//         (post?.fileUrls
//                 .where((AttachmentEntity a) => a.type == AttachmentType.image)
//                 .length ??
//             0);

// // Count videos
//     final int videoCount = _attachments
//             .where((PickedAttachment a) => a.type == AttachmentType.video)
//             .length +
//         (post?.fileUrls
//                 .where((AttachmentEntity a) => a.type == AttachmentType.video)
//                 .length ??
//             0);
//     if (imageCount == 0 || videoCount == 0) {
//       AppSnackBar.showSnackBar(
//           context, 'please_add_at_least_one_photo_and_video'.tr());
//       return;
//     }
//     if (sizeColorEntities.isEmpty && listingType == ListingType.clothAndFoot) {
//       AppSnackBar.showSnackBar(context, 'select_your_size_and_color'.tr());
//       return;
//     }
//     bool allClosed = availability.isNotEmpty &&
//         availability.every((AvailabilityEntity item) => !item.isOpen);
//     if (allClosed &&
//         (listingType == ListingType.vehicle ||
//             listingType == ListingType.property ||
//             listingType == ListingType.pets)) {
//       AppSnackBar.showSnackBar(context, 'add_availbility_for_viewing'.tr());
//       return;
//     }
//     if (selectedCategory == null &&
//         (listingType == ListingType.items ||
//             listingType == ListingType.clothAndFoot ||
//             listingType == ListingType.foodAndDrink)) {
//       AppSnackBar.showSnackBar(context, 'select_category'.tr());
//       return;
//     }
//     setLoading(true);
//     switch (listingType) {
//       case ListingType.items:
//         await _onItemSubmit();
//         break;
//       case ListingType.clothAndFoot:
//         await _onClothesAndFootSubmit();
//         break;
//       case ListingType.vehicle:
//         await _onVehicleSubmit();
//         break;
//       case ListingType.foodAndDrink:
//         await _onFoodAndDrinkSubmit();
//         break;

//       case ListingType.property:
//         await _onPropertySubmit();
//         break;
//       case ListingType.pets:
//         await _onPetSubmit();
//         break;
//       default:
//         break;
//     }
//     setLoading(false);
//     debugPrint('submition function completed here');
//   }

//   PackageDetail get pkgdetail => PackageDetail(
//       length: _packageLength.text,
//       width: _packageWidth.text,
//       height: _packageHeight.text,
//       weight: '');
//   Future<void> _onItemSubmit() async {
//     if (!(_itemKey.currentState?.validate() ?? false)) return;
//     try {
//       final AddListingParam param = AddListingParam(
//         accessCode: _accessCode,
//         postID: post?.postID ?? '',
//         oldAttachments: post?.fileUrls,
//         currency: _post == null
//             ? LocalAuth.currentUser?.currency?.toUpperCase()
//             : null,
//         title: title.text,
//         description: description.text,
//         attachments: attachments,
//         price: price.text,
//         quantity: quantity.text,
//         discount: isDiscounted,
//         discounts: discounts,
//         packageDetail: pkgdetail,
//         condition: condition,
//         acceptOffer: acceptOffer,
//         minOfferAmount: minimumOffer.text,
//         privacyType: _privacy,
//         deliveryType: deliveryType,
//         listingType: listingType ?? ListingType.items,
//         category: _selectedCategory,
//         currentLatitude: 12234,
//         currentLongitude: 123456,
//         collectionLocation: selectedCollectionLocation,
//       );
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
//             name: 'AddListingProvider.onvehicleSubmit - else');
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> _onClothesAndFootSubmit() async {
//     if (!(clothesAndFootKey.currentState?.validate() ?? false)) return;
//     try {
//       final AddListingParam param = AddListingParam(
//           postID: post?.postID ?? '',
//           oldAttachments: post?.fileUrls,
//           currency: _post == null ? LocalAuth.currentUser?.currency : null,
//           title: title.text,
//           description: description.text,
//           attachments: attachments,
//           collectionLocation: _selectedCollectionLocation,
//           price: price.text,
//           quantity: quantity.text,
//           discount: isDiscounted,
//           discounts: discounts,
//           condition: condition,
//           acceptOffer: acceptOffer,
//           minOfferAmount: minimumOffer.text,
//           privacyType: _privacy,
//           deliveryType: deliveryType,
//           listingType: ListingType.clothAndFoot,
//           category: _selectedCategory,
//           currentLatitude: LocalAuth.latlng.latitude.toInt(),
//           currentLongitude: LocalAuth.latlng.longitude.toInt(),
//           brand: brand,
//           sizeColor: _sizeColorEntities,
//           type: selectedClothSubCategory);
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> _onVehicleSubmit() async {
//     if (!(_vehicleKey.currentState?.validate() ?? false)) return;
//     getAvailabilityData();
//     try {
//       final AddListingParam param = AddListingParam(
//           postID: post?.postID ?? '',
//           oldAttachments: post?.fileUrls,
//           availbility: jsonEncode(
//             _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
//           ),
//           engineSize: engineSize.text,
//           meetUpLocation: _selectedMeetupLocation,
//           mileage: mileage.text,
//           currency: _post == null ? LocalAuth.currentUser?.currency : null,
//           title: title.text,
//           description: description.text,
//           attachments: attachments,
//           price: price.text,
//           discount: isDiscounted,
//           condition: condition,
//           acceptOffer: acceptOffer,
//           minOfferAmount: minimumOffer.text,
//           collectionLocation: selectedmeetupLocation,
//           privacyType: _privacy,
//           deliveryType: deliveryType,
//           listingType: listingType ?? ListingType.vehicle,
//           category: _selectedCategory,
//           type: selectedClothSubCategory,
//           bodyType: _selectedBodyType,
//           color: _selectedVehicleColor?.value,
//           doors: doors.text,
//           emission: _emission,
//           make: _make,
//           model: model.text,
//           seats: seats.text,
//           year: year,
//           vehicleCategory: _selectedVehicleCategory.toString(),
//           currentLatitude: LocalAuth.latlng.latitude.toInt(),
//           currentLongitude: LocalAuth.latlng.longitude.toInt(),
//           milageUnit: _selectedMileageUnit,
//           transmission: transmissionType);
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
//             name: 'AddListingProvider.onvehicleSubmit - else');
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> _onFoodAndDrinkSubmit() async {
//     if (!(_foodAndDrinkKey.currentState?.validate() ?? false)) return;
//     try {
//       final AddListingParam param = AddListingParam(
//         postID: post?.postID ?? '',
//         oldAttachments: post?.fileUrls,
//         deliveryType: deliveryType,
//         quantity: quantity.text,
//         currency: _post == null ? LocalAuth.currentUser?.currency : null,
//         title: title.text,
//         description: description.text,
//         collectionLocation: selectedmeetupLocation,
//         attachments: attachments,
//         price: price.text,
//         discount: isDiscounted,
//         discounts: _discounts,
//         condition: condition,
//         acceptOffer: acceptOffer,
//         minOfferAmount: minimumOffer.text,
//         privacyType: _privacy,
//         listingType: listingType ?? ListingType.foodAndDrink,
//         category: _selectedCategory,
//         currentLatitude: 1234,
//         currentLongitude: 1234,
//       );
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> _onPropertySubmit() async {
//     if (!(_propertyKey.currentState?.validate() ?? false)) return;

//     getAvailabilityData();
//     try {
//       final AddListingParam param = AddListingParam(
//         postID: post?.postID ?? '',
//         oldAttachments: post?.fileUrls,
//         currency: _post == null ? LocalAuth.currentUser?.currency : null,
//         animalFriendly: animalFriendly.toString(),
//         parking: parking.toString(),
//         propertyType: _selectedPropertyType,
//         bathrooms: _bathroom.text,
//         bedrooms: _bedroom.text,
//         energyrating: _selectedEnergyRating,
//         garden: garden.toString(),
//         tenureType: tenureType,
//         propertyCategory: _selectedPropertySubCategory,
//         availbility: jsonEncode(
//           _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
//         ),
//         meetUpLocation: _selectedMeetupLocation,
//         collectionLocation: _selectedCollectionLocation,
//         mileage: mileage.text,
//         title: title.text,
//         description: description.text,
//         attachments: attachments,
//         price: price.text,
//         discount: isDiscounted,
//         condition: condition,
//         acceptOffer: acceptOffer,
//         minOfferAmount: minimumOffer.text,
//         privacyType: _privacy,
//         deliveryType: deliveryType,
//         listingType: listingType ?? ListingType.vehicle,
//         category: _selectedCategory,
//         currentLatitude: 1234,
//         currentLongitude: 1234,
//         milageUnit: _selectedMileageUnit,
//       );
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> _onPetSubmit() async {
//     if (!(_petKey.currentState?.validate() ?? false)) return;
//     try {
//       final AddListingParam param = AddListingParam(
//         postID: post?.postID ?? '',
//         oldAttachments: post?.fileUrls,
//         accessCode: _accessCode,
//         age: age ?? '',
//         breed: _breed,
//         healthChecked: _healthChecked,
//         petsCategory: _petCategory,
//         wormAndFleaTreated: _wormAndFleaTreated,
//         vaccinationUpToDate: _vaccinationUpToDate,
//         readyToLeave: _time,
//         quantity: _quantity.text,
//         currency: _post == null ? LocalAuth.currentUser?.currency : null,
//         animalFriendly: animalFriendly.toString(),
//         // availbility: jsonEncode(
//         //   _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
//         // ),
//         meetUpLocation: _selectedMeetupLocation,
//         title: title.text,
//         description: description.text,
//         attachments: attachments,
//         price: price.text,
//         acceptOffer: acceptOffer,
//         minOfferAmount: minimumOffer.text,
//         privacyType: _privacy,
//         deliveryType: deliveryType,
//         listingType: listingType ?? ListingType.pets,
//         currentLatitude: LocalAuth.latlng.latitude.toInt(),
//         currentLongitude: LocalAuth.latlng.latitude.toInt(),
//       );
//       final DataState<String> result = _post == null
//           ? await _addlistingUSecase(param)
//           : await _editListingUsecase(param);
//       if (result is DataSuccess) {
//         AppNavigator.pushNamedAndRemoveUntil(
//             DashboardScreen.routeName, (_) => false);
//         reset();
//       } else if (result is DataFailer) {
//         AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
//       }
//     } catch (e) {
//       AppLog.error('$e');
//     } finally {}
//   }

//   Future<void> fetchDropdownListings(String endpoint) async {
//     _isDropdownLoading = true;
//     notifyListeners();
//     try {
//       await _getCategoriesByEndPoint.call(endpoint);
//     } catch (e) {
//       debugPrint('Error fetching dropdown listings: $e');
//       // Optionally handle error
//     } finally {
//       _isDropdownLoading = false;
//       notifyListeners();
//     }
//   }

//   void setPost(PostEntity? value) {
//     _post = value;
//     AppLog.info('Post id ${post?.postID}');
//   }

//   /// Setter
//   void setListingType(ListingType? value) {
//     _listingType = value;
//     debugPrint('ListingType is ${value?.json}');
//     notifyListeners();
//   }

//   void setSelectedCategory(SubCategoryEntity? value) {
//     if (value == null) return;
//     _selectedCategory = value;
//     notifyListeners();
//   }

//   void setIsDiscount(bool value) {
//     _isDiscounted = value;
//     notifyListeners();
//   }

//   void setDiscounts(DiscountEntity value) {
//     try {
//       _discounts
//           .where((DiscountEntity element) {
//             return element.quantity == value.quantity;
//           })
//           .first
//           .discount = value.discount;
//       notifyListeners();
//     } catch (e) {
//       AppLog.error(
//         'Not Discount Found with Quantity: ${value.quantity}',
//         name: 'AddListingFormProvider.setDiscounts - catch',
//       );
//     }
//   }

//   Future<void> setImages(
//     BuildContext context, {
//     required AttachmentType type,
//   }) async {
//     int maxAttachments = 10;
//     if (type == AttachmentType.image) {
//       if (listingType == ListingType.property) {
//         maxAttachments = 30;
//       } else if (listingType == ListingType.vehicle) {
//         maxAttachments = 20;
//       }
//     } else if (type == AttachmentType.video) {
//       maxAttachments = 1;
//     }
//     final List<PickedAttachment> selectedMedia =
//         _attachments.where((PickedAttachment element) {
//       return element.selectedMedia != null && element.type == type;
//     }).toList();
//     final List<PickedAttachment>? files =
//         await Navigator.of(context).push<List<PickedAttachment>>(
//       MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
//         return PickableAttachmentScreen(
//           option: PickableAttachmentOption(
//             maxAttachments: maxAttachments,
//             allowMultiple: true,
//             type: type,
//             selectedMedia: selectedMedia
//                 .map((PickedAttachment e) => e.selectedMedia!)
//                 .toList(),
//           ),
//         );
//       }),
//     );

//     if (files != null) {
//       for (final PickedAttachment file in files) {
//         final int index = _attachments.indexWhere((PickedAttachment element) =>
//             element.selectedMedia == file.selectedMedia);
//         if (index == -1) {
//           _attachments.add(file);
//         }
//       }
//       notifyListeners();
//     }
//   }

//   void removePickedAttachment(PickedAttachment attachment) {
//     _attachments.remove(attachment);
//     notifyListeners();
//   }

//   void removeAttachmentEntity(AttachmentEntity attachment) {
//     _post?.fileUrls.remove(attachment);
//     notifyListeners();
//   }

//   void setCondition(ConditionType value) {
//     _condition = value;
//     notifyListeners();
//   }

//   void setAcceptOffer(bool value) {
//     _acceptOffer = value;
//     notifyListeners();
//   }

//   void setPrivacy(PrivacyType value) {
//     _privacy = value;
//     notifyListeners();
//   }

//   void incrementQuantity() {
//     final int value = int.parse(_quantity.text);
//     _quantity.text = (value + 1).toString();
//     notifyListeners();
//   }

//   void decrementQuantity() {
//     final int value = int.parse(_quantity.text);
//     if (value > 1) {
//       _quantity.text = (value - 1).toString();
//       notifyListeners();
//     }
//   }

//   void setDeliveryType(DeliveryType? value) {
//     if (value == null || _deliveryType == value) return;
//     _deliveryType = value;
//     notifyListeners();
//   }

//   void setDeliveryPayer(DeliveryPayer? value) {
//     if (value == null || _deliveryPayer == value) return;

//     _deliveryPayer = value;

//     switch (value) {
//       case DeliveryPayer.sellerPays:
//         _deliveryType = DeliveryType.freeDelivery;
//         break;
//       case DeliveryPayer.buyerPays:
//         _deliveryType = DeliveryType.paid;
//         break;
//     }

//     notifyListeners();
//   }

//   void setCollectionLocation(LocationEntity location, LatLng latlng) {
//     _selectedCollectionLocation = location;
//     _collectionLatLng = latlng;
//     notifyListeners();
//   }

//   void setMeetupLocation(LocationEntity value, LatLng latlng) {
//     _selectedMeetupLocation = value;
//     _meetupLatLng = latlng;
//     notifyListeners();
//   }

//   // Cloth and Foot
//   void setSelectedClothSubCategory(String value) {
//     _selectedClothSubCategory = value;
//     _selectedCategory = null;
//     _sizeColorEntities = <SizeColorEntity>[];
//     _brand = null;
//     notifyListeners();
//   }

//   void setSelectedPropertySubCategory(String value) {
//     _selectedClothSubCategory = value;
//     notifyListeners();
//   }

//   void setBrand(String? value) {
//     _brand = value;
//     notifyListeners();
//   }

//   // Vehicle
//   void setTransmissionType(String? value) {
//     _transmissionType = value;
//     notifyListeners();
//   }

//   void setFuelType(String? value) {
//     _fuelType = value;
//     notifyListeners();
//   }

//   void setMileageUnit(String? unit) {
//     _selectedMileageUnit = unit;
//     notifyListeners();
//   }

//   void setVehicleColor(ColorOptionEntity? value) {
//     _selectedVehicleColor = value;
//     notifyListeners();
//   }

//   void setBodyType(String? type) {
//     _selectedBodyType = type;
//     notifyListeners();
//   }

//   void setVehicleCategory(String? type) {
//     _selectedVehicleCategory = type;
//     notifyListeners();
//   }

//   // Property
//   void setGarden(bool? value) {
//     if (value == null) return;
//     _garden = value;
//     notifyListeners();
//   }

//   void setParking(bool? value) {
//     if (value == null) return;
//     _parking = value;
//     notifyListeners();
//   }

//   void setAnimalFriendly(bool? value) {
//     if (value == null) return;
//     _animalFriendly = value;
//     notifyListeners();
//   }

//   void setPropertyType(String? value) {
//     _selectedPropertyType = value;
//     notifyListeners();
//   }

//   void setEnergyRating(String? value) {
//     _selectedEnergyRating = value;
//     notifyListeners();
//   }

//   void setSelectedTenureType(String value) {
//     _tenureType = value;
//     notifyListeners();
//   }

//   void setTime(String? value) {
//     if (value == null) return;
//     _time = value;
//     notifyListeners();
//   }

//   void setAccessCode(String? value) {
//     if (value == null) return;
//     _accessCode = value;
//     // notifyListeners();
//   }

// // pets
//   void setPetCategory(String? category) {
//     _petCategory = category;
//     notifyListeners();
//   }

//   void setPetBreed(String? value) {
//     _breed = value;
//     notifyListeners();
//   }

//   void setPetBreeds(String category) {
//     _petCategory = category;
//     notifyListeners();
//   }

//   void setVaccinationUpToDate(bool? value) {
//     _vaccinationUpToDate = value;
//     notifyListeners();
//   }

//   void setWormFleeTreated(bool? value) {
//     _wormAndFleaTreated = value;
//     notifyListeners();
//   }

//   void setHealthChecked(bool? value) {
//     _healthChecked = value;
//     notifyListeners();
//   }

//   void setAge(String? value) {
//     if (value == null) return;
//     _age = value;
//     notifyListeners();
//   }

//   void setemissionType(String? value) {
//     _emission = value;
//     notifyListeners();
//   }

//   void seteMake(String? value) {
//     _make = value;
//     notifyListeners();
//   }

//   void setYear(String? value) {
//     _year = value;
//     notifyListeners();
//   }
// //?

//   void setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void addOrUpdateSizeColorQuantity({
//     required String size,
//     required ColorOptionEntity color,
//     required int quantity,
//   }) {
//     // Find the size entry
//     final int sizeIndex =
//         _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);

//     if (sizeIndex != -1) {
//       final SizeColorEntity existingSize = _sizeColorEntities[sizeIndex];

//       // Find if the color already exists
//       final int colorIndex = existingSize.colors
//           .indexWhere((ColorEntity c) => c.code == color.value);

//       if (colorIndex != -1) {
//         // Update quantity for existing color
//         existingSize.colors[colorIndex] =
//             ColorEntity(code: color.value, quantity: quantity);
//       } else {
//         // Add new color to existing size
//         existingSize.colors.add(
//           ColorEntity(code: color.value, quantity: quantity),
//         );
//         debugPrint('Added new color: ${color.value}');
//       }
//     } else {
//       // Add new size with color
//       _sizeColorEntities.add(
//         SizeColorModel(
//           value: size,
//           id: size,
//           colors: <ColorEntity>[
//             ColorEntity(code: color.value, quantity: quantity),
//           ],
//         ),
//       );
//       debugPrint('Added new size: $size with color: ${color.value}');
//     }

//     notifyListeners();
//   }

//   /// Removes a specific color from a specific size.
//   /// If that size has no more colors left, the size entry is removed.
//   void removeColorFromSize({
//     required String size,
//     required String color,
//   }) {
//     final int sizeIndex =
//         _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);
//     if (sizeIndex != -1) {
//       _sizeColorEntities[sizeIndex]
//           .colors
//           .removeWhere((ColorEntity c) => c.code == color);

//       // If no colors left, remove the size entry as well
//       if (_sizeColorEntities[sizeIndex].colors.isEmpty) {
//         _sizeColorEntities.removeAt(sizeIndex);
//       }

//       notifyListeners();
//     }
//   }

//   /// Clears all size-color-quantity data.

//   // Future<List<ColorOptionEntity>> colorOptions() async {
//   //   final String jsonString =
//   //       await rootBundle.loadString('assets/jsons/colors.json');
//   //   final Map<String, dynamic> colorsMap = jsonDecode(jsonString);
//   //   final Map<String, dynamic> colors = colorsMap['colors'];
//   //   return colors.entries.map((MapEntry<String, dynamic> entry) {
//   //     return ColorOptionModel.fromJson(entry.value);
//   //   }).toList();
//   // }

//   // // Load colors into the provider
//   // Future<void> fetchColors() async {
//   //   _colors = await colorOptions();
//   //   notifyListeners();
//   // }

//   /// Getter
//   ListingType? get listingType => _listingType ?? ListingType.items;
//   bool get isDropdownLoading => _isDropdownLoading;
//   SubCategoryEntity? get selectedCategory => _selectedCategory;
//   String? get selectedVehicleCategory => _selectedVehicleCategory;
//   PostEntity? get post => _post;

//   bool get isDiscounted => _isDiscounted;
//   List<DiscountEntity> get discounts => _discounts;
//   List<SizeColorEntity> get sizeColorEntities => _sizeColorEntities;
//   LocationEntity? get selectedmeetupLocation => _selectedMeetupLocation;
//   LocationEntity? get selectedCollectionLocation => _selectedCollectionLocation;
//   LatLng? get meetupLatLng => _meetupLatLng;
//   LatLng? get collectionLatLng => _collectionLatLng;

//   //
//   List<PickedAttachment> get attachments => _attachments;
//   ConditionType get condition => _condition;
//   bool get acceptOffer => _acceptOffer;
//   PrivacyType get privacy => _privacy;
//   DeliveryType get deliveryType => _deliveryType;
//   DeliveryPayer get deliveryPayer => _deliveryPayer;

//   // Cloth and Foot
//   String get selectedClothSubCategory => _selectedClothSubCategory;
//   String? get brand => _brand;
//   List<ColorOptionEntity> get colors => _colors;
//   ColorOptionEntity? get selectedVehicleColor => _selectedVehicleColor;
//   // Vehicle
//   String? get transmissionType => _transmissionType;
//   String? get fuelTYpe => _fuelType;
//   String? get selectedMileageUnit => _selectedMileageUnit;
//   TextEditingController get engineSize => _engineSize;
//   TextEditingController get mileage => _mileage;
//   String? get selectedBodyType => _selectedBodyType;
//   String? get make => _make;
//   TextEditingController get model => _model;
//   String? get year => _year;
//   String? get emission => _emission;
//   TextEditingController get doors => _doors;
//   TextEditingController get seats => _seats;
//   TextEditingController get location => _location;
//   // Property
//   TextEditingController get bedroom => _bedroom;
//   TextEditingController get bathroom => _bathroom;
//   String get tenureType => _tenureType;
//   String? get selectedPropertySubCategory => _selectedPropertySubCategory;
//   String? get selectedPropertyType => _selectedPropertyType;
//   bool get garden => _garden;
//   bool get parking => _parking;
//   bool get animalFriendly => _animalFriendly;
//   String? get selectedEnergyRating => _selectedEnergyRating;
//   // Pet
//   String? get age => _age;
//   String? get petCategory => _petCategory;
//   bool? get healthChecked => _healthChecked;
//   String? get breed => _breed;
//   // bool? get petsCategory => _petsCategory;
//   bool? get wormAndFleaTreated => _wormAndFleaTreated;
//   bool? get vaccinationUpToDate => _vaccinationUpToDate;
//   String? get time => _time;
//   bool get isLoading => _isLoading;
//   //
//   TextEditingController get title => _title;
//   TextEditingController get description => _description;
//   TextEditingController get price => _price;
//   TextEditingController get quantity => _quantity;
//   TextEditingController get minimumOffer => _minimumOffer;
//   TextEditingController get packageHeight => _packageHeight;
//   TextEditingController get packageWidth => _packageWidth;
//   TextEditingController get packageLength => _packageLength;
//   String get accessCode => _accessCode;
//   GlobalKey<FormState> get itemKey => _itemKey;
//   GlobalKey<FormState> get clothesAndFootKey => _clothesAndFootKey;
//   GlobalKey<FormState> get vehicleKey => _vehicleKey;
//   GlobalKey<FormState> get foodAndDrinkKey => _foodAndDrinkKey;
//   GlobalKey<FormState> get propertyKey => _propertyKey;
//   GlobalKey<FormState> get petKey => _petKey;
//   List<ListingEntity> get listings => _listings;

//   //
//   /// Controller
//   final List<ListingEntity> _listings = <ListingEntity>[];
//   bool _isDropdownLoading = false;
//   PostEntity? _post;
//   ListingType? _listingType;
//   SubCategoryEntity? _selectedCategory;
//   String? _selectedVehicleCategory;
//   bool _isDiscounted = false;
//   final List<DiscountEntity> _discounts = <DiscountEntity>[
//     DiscountEntity(quantity: 2, discount: 0),
//     DiscountEntity(quantity: 3, discount: 0),
//     DiscountEntity(quantity: 5, discount: 0),
//   ];
//   // Selected Category
//   SubCategoryEntity? findCategoryByAddress(
//     List<ListingEntity> listings,
//     String address,
//   ) {
//     for (ListingEntity listing in listings) {
//       SubCategoryEntity? result =
//           _findCategoryInSubCategories(listing.subCategory, address);
//       if (result != null) {
//         return result;
//       }
//     }
//     AppLog.info('No matching category found for address: $address',
//         name: 'AddListingFormProvider - findCategoryByAddress');
//     return null;
//   }

//   SubCategoryEntity? _findCategoryInSubCategories(
//     List<SubCategoryEntity> subCategories,
//     String address,
//   ) {
//     for (SubCategoryEntity subCategory in subCategories) {
//       if (subCategory.address == address) {
//         AppLog.info('Match found: ${subCategory.toString()}',
//             name: 'AddListingFormProvider - findCategoryByAddress');
//         return subCategory; // Return the matching subCategory
//       }

//       // If this subcategory has nested subcategories, recurse through them
//       if (subCategory.subCategory.isNotEmpty) {
//         SubCategoryEntity? result =
//             _findCategoryInSubCategories(subCategory.subCategory, address);
//         if (result != null) {
//           return result;
//         }
//       }
//     }
//     return null;
//   }

//   List<SizeColorEntity> _sizeColorEntities = <SizeColorModel>[];
//   //
//   ConditionType _condition = ConditionType.newC;
//   bool _acceptOffer = true;
//   PrivacyType _privacy = PrivacyType.public;
//   DeliveryType _deliveryType = DeliveryType.paid;
//   DeliveryPayer _deliveryPayer = DeliveryPayer.sellerPays;

//   LocationEntity? _selectedMeetupLocation;
//   LatLng? _meetupLatLng;
//   LocationEntity? _selectedCollectionLocation;
//   LatLng? _collectionLatLng;
//   // Cloth and Foot
//   String _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;
//   final List<ColorOptionEntity> _colors = <ColorOptionEntity>[];
//   String? _brand;
//   // Vehicle
//   String? _transmissionType;
//   String? _fuelType;
//   final TextEditingController _engineSize = TextEditingController();
//   final TextEditingController _mileage = TextEditingController();
//   String? _make;
//   final TextEditingController _model = TextEditingController();
//   String? _year;
//   String? _emission;
//   final TextEditingController _doors = TextEditingController();
//   final TextEditingController _seats = TextEditingController();
//   final TextEditingController _location = TextEditingController();
//   String? _selectedBodyType;
//   ColorOptionEntity? _selectedVehicleColor;
//   String? _selectedMileageUnit;
//   // Property
//   final TextEditingController _bedroom = TextEditingController();
//   final TextEditingController _bathroom = TextEditingController();
//   String _tenureType = TenureType.freehold.value;
//   String _selectedPropertySubCategory = ListingType.property.cids.first;
//   String? _selectedEnergyRating;
//   String? _selectedPropertyType;

//   bool _garden = true;
//   bool _parking = true;
//   bool _animalFriendly = true;
//   // Pet
//   String? _petCategory;
//   bool? _healthChecked;
//   String? _breed;
//   // bool _petsCategory;
//   bool? _wormAndFleaTreated;
//   bool? _vaccinationUpToDate;
//   String? _age;
//   String? _time;
//   bool _isLoading = false;
//   //
//   List<PickedAttachment> _attachments = <PickedAttachment>[];
//   final TextEditingController _title = TextEditingController();
//   final TextEditingController _description = TextEditingController();
//   final TextEditingController _price = TextEditingController();
//   final TextEditingController _quantity = TextEditingController(text: '1');
//   final TextEditingController _minimumOffer = TextEditingController();
//   final TextEditingController _packageHeight = TextEditingController();
//   final TextEditingController _packageWidth = TextEditingController();
//   final TextEditingController _packageLength = TextEditingController();
//   String _accessCode = '';
//   // Form State
//   final GlobalKey<FormState> _itemKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _clothesAndFootKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _vehicleKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _foodAndDrinkKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _propertyKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _petKey = GlobalKey<FormState>();

// //
//   @override
//   void dispose() {
//     reset();
//     super.dispose();
//   }
// }