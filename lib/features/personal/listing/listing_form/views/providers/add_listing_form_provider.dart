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
import '../../../../post/domain/entities/post/post_pet_entity.dart';
import '../../../../post/domain/entities/post/post_property_entity.dart';
import '../../../../post/domain/entities/post/post_vehicle_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../data/models/sub_category_model.dart';
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
  List<DiscountEntity> get discounts => _state.discounts;
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

  // State delegation - Setters
  void startediting(PostEntity value) {
    _post = value;
    AppLog.info('Editing post initialized — ID: ${value.postID}');
    initializeForEdit(value);
    AppNavigator.pushNamed(AddListingFormScreen.routeName);
    notifyListeners();
  }

  void setListingType(ListingType? value) {
    _state.listingType = value;
    notifyListeners();
  }

  void setSelectedCategory(SubCategoryEntity? value) {
    if (value == null) return;
    _state.selectedCategory = value;
    notifyListeners();
  }

  void setIsDiscount(bool value) {
    _state.isDiscounted = value;
    notifyListeners();
  }

  void setDiscounts(DiscountEntity value) {
    try {
      final DiscountEntity discount = discounts.firstWhere(
          (DiscountEntity element) => element.quantity == value.quantity);
      discount.discount = value.discount;
      notifyListeners();
    } catch (e) {
      AppLog.error('Not Discount Found with Quantity: ${value.quantity}');
    }
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
    notifyListeners();
  }

  void setLoading(bool value) {
    _state.isLoading = value;
    notifyListeners();
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

    notifyListeners();
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
    if (selectedCategory == null) {
      return (false, 'choose_category'.tr());
    }

    if (!hasAtLeastOnePhoto) {
      return (false, 'please_add_at_least_one_photo'.tr());
    }

    // Parcel size check (when delivery requires it)
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
      discount: isDiscounted,
      discounts: isDiscounted ? discounts : null,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      packageDetail:
          deliveryType != DeliveryType.collection ? pkgDetails : null,
      collectionLocation: selectedCollectionLocation,
      meetUpLocation: selectedMeetupLocation,
      availbility: availability.isNotEmpty ? availability.toString() : null,
    );

    await _submitCommon(param);
  }

  Future<void> _onPetSubmit() async {
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
      petsParams: PostPetEntity(
        address: '',
        age: _state.age,
        breed: _state.breed,
        healthChecked: _state.healthChecked,
        petsCategory: _state.petCategory,
        readyToLeave: _state.readyToLeave,
        vaccinationUpToDate: _state.vaccinationUpToDate,
        wormAndFleaTreated: _state.wormAndFleaTreated,
      ),
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      meetUpLocation: selectedMeetupLocation,
    );
    await _submitCommon(param);
  }

  Future<void> _onClothesAndFootSubmit() async {
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
      discount: isDiscounted,
      discounts: isDiscounted ? discounts : null,
      clothfootParams: PostClothFootEntity(
        address: '',
        sizeColors: _state.sizeColorEntities,
        sizeChartUrl: null,
        brand: _state.brand ?? '',
      ),
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
      discount: isDiscounted,
      discounts: isDiscounted ? discounts : null,
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      packageDetail:
          deliveryType != DeliveryType.collection ? pkgDetails : null,
      collectionLocation: selectedCollectionLocation,
      meetUpLocation: selectedMeetupLocation,
      availbility: availability.isNotEmpty ? availability.toString() : null,
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
      availbility: availability.isNotEmpty ? availability.toString() : null,
    );

    await _submitCommon(param);
  }

  Future<void> _onVehicleSubmit() async {
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
      vehicleParams: PostVehicleEntity(
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
        exteriorColor: _state.exteriorColor ?? '',
        vehiclesCategory: _state.vehicleCategory ?? '',
      ),
      currentLatitude: LocalAuth.latlng.latitude,
      currentLongitude: LocalAuth.latlng.longitude,
      meetUpLocation: selectedMeetupLocation,
      availbility: availability.isNotEmpty ? availability.toString() : null,
    );

    await _submitCommon(param);
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
    notifyListeners();
  }

  void addAttachment(PickedAttachment attachment) {
    _attachmentManager.add(attachment);
    notifyListeners();
  }

  void removePickedAttachment(PickedAttachment attachment) {
    _attachmentManager.remove(attachment);
    notifyListeners();
  }

  void removeAttachmentEntity(AttachmentEntity attachment) {
    _post?.fileUrls.remove(attachment);
    notifyListeners();
  }

  // Utility methods
  void incrementQuantity() {
    final int value = int.tryParse(_state.quantity.text) ?? 1;
    _state.quantity.text = (value + 1).toString();
    notifyListeners();
  }

  void decrementQuantity() {
    final int value = int.tryParse(_state.quantity.text) ?? 1;
    if (value > 1) {
      _state.quantity.text = (value - 1).toString();
      notifyListeners();
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
    _state.isDiscounted = post.hasDiscount;
    _state.privacy = post.privacy;
    // _state.selectedCategory =
    //     LocalCategoriesSource().findSubCategoryByAddress(post.);

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

    AppLog.info('Editing post initialized — ID: ${post.postID}');
    notifyListeners();
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

    notifyListeners();
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
    state.brand = clothInfo.brand;
    state.sizeColorEntities
      ..clear()
      ..addAll(_cloneSizeColors(clothInfo.sizeColors));
    notifyListeners();
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
                  address: '',
                  sizeColors: _cloneSizeColors(_state.sizeColorEntities),
                  sizeChartUrl: null,
                  brand: _state.brand ?? '',
                )
              : PostClothFootEntity(
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
        discounts: discounts,
        clothFootInfo: previewClothInfo,
        propertyInfo: previewPropertyInfo,
        petInfo: previewPetInfo,
        vehicleInfo: previewVehicleInfo,
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
      AppLog.error('Error generating preview: $e\n$st');
      AppSnackBar.errorGlobal('preview_error'.tr());
    }
  }
}
