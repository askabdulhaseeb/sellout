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
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../post/domain/entities/meetup/availability_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/post/post_cloth_foot_entity.dart';
import '../../../../post/domain/entities/post/package_detail_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/sources/local/local_categories.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecase/add_listing_usecase.dart';
import '../../domain/usecase/edit_listing_usecase.dart';
import '../params/add_listing_param.dart';
import '../screens/add_listing_form_screen.dart';
import '../widgets/core/delivery_Section.dart/add_listing_delivery_selection_widget.dart';
import 'form_state/add_listing_form_state.dart';
import 'managers/availability_manager.dart';
import 'mixins/cloth_listing_mixin.dart';
import 'mixins/food_listing_mixin.dart';
import 'mixins/pet_listing_mixin.dart';
import 'mixins/property_listing_mixin.dart';
import 'mixins/vehicle_listing_mixin.dart';

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

  List<PickedAttachment> _attachments = <PickedAttachment>[];
  PostEntity? _post;
  final List<ListingEntity> _listings = <ListingEntity>[];

  // Form keys
  final GlobalKey<FormState> itemKey = GlobalKey<FormState>();
  final GlobalKey<FormState> clothesAndFootKey = GlobalKey<FormState>();
  final GlobalKey<FormState> vehicleKey = GlobalKey<FormState>();
  final GlobalKey<FormState> foodAndDrinkKey = GlobalKey<FormState>();
  final GlobalKey<FormState> propertyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> petKey = GlobalKey<FormState>();

  // Mixin state accessor
  @override
  AddListingFormState get state => _state;

  // Availability delegation
  List<AvailabilityEntity> get availability =>
      _availabilityManager.availability;
  List<String> generateTimeSlots() => _availabilityManager.generateTimeSlots();
  void toggleOpen(DayType day, bool isOpen) =>
      _availabilityManager.toggleOpen(day, isOpen);
  void setOpeningTime(DayType day, String time) =>
      _availabilityManager.setOpeningTime(day, time);
  void setClosingTime(DayType day, String time) =>
      _availabilityManager.setClosingTime(day, time);
  void updateOpeningTime(DayType day, String time) =>
      _availabilityManager.updateOpeningTime(day, time);
  bool isClosingTimeValid(String openingTime, String closingTime) =>
      _availabilityManager.isClosingTimeValid(openingTime, closingTime);
  TimeOfDay parseTimeString(String timeString) =>
      _availabilityManager.parseTimeString(timeString);

  // State delegation - Getters
  ListingType? get listingType => _state.listingType ?? ListingType.items;
  bool get isDropdownLoading => _state.isDropdownLoading;
  SubCategoryEntity? get selectedCategory => _state.selectedCategory;
  PostEntity? get post => _post;
  bool get isDiscounted => _state.isDiscounted;
  List<DiscountEntity> get discounts => _state.discounts;
  LocationEntity? get selectedMeetupLocation => _state
      .selectedMeetupLocation; // Fixed typo: selectedmeetupLocation -> selectedMeetupLocation
  LocationEntity? get selectedCollectionLocation =>
      _state.selectedCollectionLocation;
  LatLng? get meetupLatLng => _state.meetupLatLng;
  LatLng? get collectionLatLng => _state.collectionLatLng;
  List<PickedAttachment> get attachments => _attachments;
  ConditionType get condition => _state.condition;
  bool get acceptOffer => _state.acceptOffer;
  PrivacyType get privacy => _state.privacy;
  DeliveryType get deliveryType => _state.deliveryType;
  DeliveryPayer get deliveryPayer => _state.deliveryPayer;
  bool get isLoading => _state.isLoading;
  String get accessCode => _state.accessCode;
  List<ListingEntity> get listings => _listings;

  // TextEditingController getters
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
  TextEditingController get bedroom => _state.bedroom;
  TextEditingController get bathroom => _state.bathroom;
  TextEditingController get packageHeight => _state.packageHeight;
  TextEditingController get packageWidth => _state.packageWidth;
  TextEditingController get packageLength => _state.packageLength;
  TextEditingController get packageWeight => _state.packageWeight;

  // State delegation - Setters
  void startediting(PostEntity value) {
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
    notifyListeners();
  }

  // Core methods
  Future<void> reset() async {
    _state.reset();
    _availabilityManager.reset();
    _attachments = <PickedAttachment>[];
    _post = null;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (!await _validateForm(context)) return;

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
        default:
          break;
      }
    } catch (e, st) {
      AppLog.error('Error during submission: $e\n$st');
      // TODO: show user friendly error (snackbar/dialog) if desired
    } finally {
      setLoading(false);
    }
  }

  // Attachment validation helpers
  bool get hasAtLeastOnePhoto {
    final int newPhotos = _attachments
        .where((PickedAttachment attachment) =>
            attachment.type == AttachmentType.image)
        .length;
    final int oldPhotos = _post?.fileUrls
            .where((AttachmentEntity attachment) => attachment.type == 'image')
            .length ??
        0;
    return (newPhotos + oldPhotos) >= 1;
  }

  bool get hasAtLeastOneVideo {
    final int newVideos = _attachments
        .where((PickedAttachment attachment) =>
            attachment.type == AttachmentType.video)
        .length;
    final int oldVideos = _post?.fileUrls
            .where((AttachmentEntity attachment) =>
                attachment.type == AttachmentType.image)
            .length ??
        0;
    return (newVideos + oldVideos) >= 1;
  }

  int get totalPhotos {
    final int newPhotos = _attachments
        .where((PickedAttachment attachment) =>
            attachment.type == AttachmentType.image)
        .length;
    final int oldPhotos = _post?.fileUrls
            .where((AttachmentEntity attachment) =>
                attachment.type == AttachmentType.image)
            .length ??
        0;
    return newPhotos + oldPhotos;
  }

  int get totalVideos {
    final int newVideos = _attachments
        .where((PickedAttachment attachment) =>
            attachment.type == AttachmentType.video)
        .length;
    final int oldVideos = _post?.fileUrls
            .where((AttachmentEntity attachment) =>
                attachment.type == AttachmentType.video)
            .length ??
        0;
    return newVideos + oldVideos;
  }

  /// Validates basic form requirements (attachments, category, title)
  /// Shows snackbar for the first validation error found
  /// Does NOT validate form-specific fields (use validateFormState for that)
  bool validateBasicForm(BuildContext context) {
    if (!hasAtLeastOnePhoto) {
      AppLog.error('At least one photo is required');
      AppSnackBar.error(
          context, 'please_add_at_least_one_photo_and_video'.tr());
      return false;
    }

    if (!hasAtLeastOneVideo) {
      AppLog.error('At least one video is required');
      AppSnackBar.error(
          context, 'please_add_at_least_one_photo_and_video'.tr());
      return false;
    }

    if (selectedCategory == null) {
      AppSnackBar.error(context, 'choose_category'.tr());
      return false;
    }

    return true;
  }

  /// Validates form-specific fields based on listing type
  bool validateFormState() {
    switch (listingType) {
      case ListingType.vehicle:
        return vehicleKey.currentState?.validate() ?? false;
      case ListingType.clothAndFoot:
        return clothesAndFootKey.currentState?.validate() ?? false;
      case ListingType.property:
        return propertyKey.currentState?.validate() ?? false;
      case ListingType.pets:
        return petKey.currentState?.validate() ?? false;
      default:
        return itemKey.currentState?.validate() ?? false;
    }
  }

  Future<bool> _validateForm(BuildContext context) async {
    // Validate basic requirements first
    if (!validateBasicForm(context)) return false;

    // Then validate form-specific fields
    if (!validateFormState()) return false;

    return true;
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
        accessCode: accessCode,
        postID: post?.postID,
        title: title.text,
        description: description.text,
        attachments: _attachments,
        oldAttachments: _post?.fileUrls,
        price: price.text,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: privacy,
        deliveryType: deliveryType,
        listingType: listingType!,
        // currency: LocalAuth.currency,
        category: selectedCategory,
        condition: condition,
        quantity: quantity.text,
        discount: isDiscounted,
        currentLatitude: LocalAuth.latlng.latitude,
        currentLongitude: LocalAuth.latlng.longitude,
        collectionLocation: _state.selectedCollectionLocation);

    await _submitCommon(param);
  }

  Future<void> _onPetSubmit() async {
    final AddListingParam param = AddListingParam(
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachments,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType!,
      // currency: LocalAuth.currency,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      // Pet-specific fields
      age: age,
      breed: breed,
      vaccinationUpToDate: vaccinationUpToDate,
      wormAndFleaTreated: wormAndFleaTreated,
      healthChecked: healthChecked,
    );

    await _submitCommon(param);
  }

  Future<void> _onClothesAndFootSubmit() async {
    final AddListingParam param = AddListingParam(
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachments,
      oldAttachments: _post?.fileUrls,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType!,
      // currency: LocalAuth.currency,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      brand: brand,
      // sizeColorEntities: sizeColorEntities,
    );

    await _submitCommon(param);
  }

  Future<void> _onFoodAndDrinkSubmit() async {
    final AddListingParam param = AddListingParam(
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachments,
      oldAttachments: _post?.fileUrls,

      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType!,
      // currency: LocalAuth.currency,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      availbility: _availabilityManager.availability.toString(),
    );

    await _submitCommon(param);
  }

  Future<void> _onPropertySubmit() async {
    final AddListingParam param = AddListingParam(
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachments,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType!,
      // currency: LocalAuth.currency,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      // Property-specific fields
      bedrooms: bedroom.text,
      bathrooms: bathroom.text,
      garden: garden.toString(),
      parking: parking.toString(),
      animalFriendly: animalFriendly.toString(),
      tenureType: tenureType,
      propertyType: selectedPropertyType,
      energyrating: selectedEnergyRating,
    );

    await _submitCommon(param);
  }

  Future<void> _onVehicleSubmit() async {
    final AddListingParam param = AddListingParam(
      accessCode: accessCode,
      postID: post?.postID,
      title: title.text,
      description: description.text,
      attachments: _attachments,
      price: price.text,
      acceptOffer: acceptOffer,
      minOfferAmount: minimumOffer.text,
      privacyType: privacy,
      deliveryType: deliveryType,
      listingType: listingType!,
      // currency: LocalAuth.currency,
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      // Vehicle-specific fields
      engineSize: engineSize.text,
      mileage: mileage.text,
      model: model.text,
      doors: doors.text,
      seats: seats.text,
      transmission: transmissionType,
      fuelType: fuelType,
      make: make,
      year: year,
      emission: emission,
      bodyType: selectedBodyType,
      vehicleCategory: selectedVehicleCategory,
      mileageUnit: selectedMileageUnit,
      // color: selectedVehicleColor.,
    );

    await _submitCommon(param);
  }

  void _handleSubmissionResult(DataState<String> result) {
    if (result is DataSuccess) {
      AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName, (_) => false);
      reset();
    } else if (result is DataFailer) {
      AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
    } else {
      AppLog.error('Unknown submission result state');
    }
  }

  // Attachment methods
  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    int maxAttachments = 10;
    if (type == AttachmentType.image) {
      if (listingType == ListingType.property) {
        maxAttachments = 30;
      } else if (listingType == ListingType.vehicle) {
        maxAttachments = 20;
      }
    } else if (type == AttachmentType.video) {
      maxAttachments = 1;
    }
    final List<PickedAttachment> selectedMedia =
        _attachments.where((PickedAttachment element) {
      return element.selectedMedia != null && element.type == type;
    }).toList();
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: maxAttachments,
            allowMultiple: true,
            type: type,
            selectedMedia: selectedMedia
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        );
      }),
    );

    if (files != null) {
      for (final PickedAttachment file in files) {
        final int index = _attachments.indexWhere((PickedAttachment element) =>
            element.selectedMedia == file.selectedMedia);
        if (index == -1) {
          _attachments.add(file);
        }
      }
      notifyListeners();
    }
  }

  void addAttachment(PickedAttachment attachment) {
    _attachments.add(attachment);
    notifyListeners();
  }

  void removePickedAttachment(PickedAttachment attachment) {
    _attachments.remove(attachment);
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
    // Basic listing details
    title.text = post.title;
    description.text = post.description;
    price.text = post.price.toString();
    quantity.text = post.quantity.toString();
    minimumOffer.text = post.minOfferAmount.toString();

    // Type and category
    try {
      _state.listingType = ListingType.fromJson(post.listID);
    } catch (_) {
      _state.listingType = ListingType.items;
    }

    // Conditions and settings
    _state.condition = post.condition;
    _state.acceptOffer = post.acceptOffers;
    _state.isDiscounted = post.hasDiscount;
    _state.privacy = post.privacy;
    _state.selectedCategory =
        LocalCategoriesSource().findSubCategoryByAddress(post.address);
    // Vehicle / Property specific fields
    _state.engineSize.text = post.vehicleInfo?.engineSize?.toString() ?? '';
    _state.mileage.text = post.vehicleInfo?.mileage?.toString() ?? '';
    _state.model.text = post.vehicleInfo?.model?.toString() ?? '';
    _state.doors.text = post.vehicleInfo?.doors?.toString() ?? '';
    _state.seats.text = post.vehicleInfo?.seats?.toString() ?? '';
    _state.location.text = post.meetUpLocation?.address?.toString() ?? '';
    _state.bedroom.text = post.propertyInfo?.bedroom?.toString() ?? '';
    _state.bathroom.text = post.propertyInfo?.bathroom?.toString() ?? '';

    // Locations
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
    // delivery
    _state.deliveryType = post.deliveryType;
    _state.packageHeight.text = post.packageDetail.height.toString();
    _state.packageWidth.text = post.packageDetail.width.toString();
    _state.packageLength.text = post.packageDetail.length.toString();
    _state.packageWeight.text = post.packageDetail.weight.toString();

    // Availability
    if (post.availability != null) {
      _availabilityManager.setAvailabilty(post.availability!);
    }

    // TODO: Initialize mixin-specific fields from post data
    // This would require extending PostEntity to include these fields

    AppLog.info('Editing post initialized — ID: ${post.postID}');
    notifyListeners();
  }

  /// Creates a temporary PostEntity from current form data for preview purposes
  /// For new listings: Creates dummy PostEntity with form data
  /// For editing: Returns existing PostEntity
  PostEntity? createPostFromFormData() {
    try {
      // Same validation as submit function
      if (!hasAtLeastOnePhoto) {
        AppLog.info(
            'Preview validation failed: At least one photo is required');
        return null;
      }

      if (!hasAtLeastOneVideo) {
        AppLog.info(
            'Preview validation failed: At least one video is required');
        return null;
      }

      if (selectedCategory == null) {
        AppLog.info('Preview validation failed: Category not selected');
        return null;
      }

      if (title.text.isEmpty) {
        AppLog.info('Preview validation failed: Title is empty');
        return null;
      }

      // If editing an existing post, use that and show updated attachments
      if (_post != null) {
        return _post;
      }

      // For new post preview, create a dummy PostEntity with form data
      final PostEntity dummyPost = PostEntity(
        listID: 'preview_list_${DateTime.now().millisecondsSinceEpoch}',
        postID: 'preview_${DateTime.now().millisecondsSinceEpoch}',
        businessID: null,
        title: title.text,
        description: description.text,
        price: double.tryParse(price.text) ?? 0.0,
        quantity: int.tryParse(quantity.text) ?? 1,
        currency: LocalAuth.currency,
        type: listingType ?? ListingType.items,
        address: selectedMeetupLocation?.address ?? 'Your Location',
        acceptOffers: acceptOffer,
        minOfferAmount: double.tryParse(minimumOffer.text) ?? 0.0,
        privacy: privacy,
        condition: condition,
        listOfReviews: <double>[],
        categoryType: selectedCategory?.title ?? 'General',
        //
        currentLongitude: LocalAuth.latlng.longitude,
        currentLatitude: LocalAuth.latlng.latitude,
        collectionLatitude: selectedCollectionLocation?.latitude,
        collectionLongitude: selectedCollectionLocation?.longitude,
        collectionLocation: selectedCollectionLocation,
        meetUpLocation: selectedMeetupLocation,
        //delivery
        deliveryType: deliveryType,
        localDelivery: 1,
        internationalDelivery: null,
        //
        availability: availability.isNotEmpty ? availability : null,
        //
        fileUrls: <AttachmentEntity>[],
        //
        hasDiscount: isDiscounted,
        discounts: discounts,
        //
        clothFootInfo: PostClothFootEntity(
          sizeColors: <SizeColorEntity>[],
          sizeChartUrl: null,
          brand: brand,
        ),
        propertyInfo: null,
        petInfo: null,
        vehicleInfo: null,
        packageDetail: PackageDetailEntity(
          length: 0.0,
          width: 0.0,
          height: 0.0,
          weight: 0.0,
        ),
        //
        isActive: true,
        createdBy: LocalAuth.uid ?? 'current_user',
        updatedBy: LocalAuth.uid ?? 'current_user',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        accessCode: accessCode,
      );

      AppLog.info('Preview: Created dummy post for new listing preview');
      return dummyPost;
    } catch (e, st) {
      AppLog.error('Error creating preview post: $e\n$st');
      return null;
    }
  }

  /// Gets preview attachments combining new and old ones
  List<AttachmentEntity> getPreviewAttachments() {
    return <AttachmentEntity>[
      // Existing attachments from post
      if (_post?.fileUrls != null) ..._post!.fileUrls,
      // New attachments (as placeholder since they're not uploaded yet)
      // These won't have URLs until uploaded
    ];
  }

  /// Gets basic preview data as a map for UI display
  Map<String, dynamic> getPreviewData() {
    return <String, dynamic>{
      'title': title.text,
      'description': description.text,
      'price': price.text,
      'quantity': quantity.text,
      'category': selectedCategory,
      'condition': condition,
      'attachment_count': _attachments.length,
      'has_new_attachments': _attachments.isNotEmpty,
    };
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
