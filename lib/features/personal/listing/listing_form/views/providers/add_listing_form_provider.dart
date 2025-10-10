import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/meetup/availability_entity.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../location/domain/entities/location_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../domain/usecase/add_listing_usecase.dart';
import '../../domain/usecase/edit_listing_usecase.dart';
import '../params/add_listing_param.dart';
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
  LocationEntity? get selectedmeetupLocation => _state.selectedMeetupLocation;
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
  TextEditingController get engineSize => _state.engineSize;
  TextEditingController get mileage => _state.mileage;
  TextEditingController get model => _state.model;
  TextEditingController get doors => _state.doors;
  TextEditingController get seats => _state.seats;
  TextEditingController get location => _state.location;
  TextEditingController get bedroom => _state.bedroom;
  TextEditingController get bathroom => _state.bathroom;
  bool get isLoading => _state.isLoading;
  TextEditingController get title => _state.title;
  TextEditingController get description => _state.description;
  TextEditingController get price => _state.price;
  TextEditingController get quantity => _state.quantity;
  TextEditingController get minimumOffer => _state.minimumOffer;
  TextEditingController get packageHeight => _state.packageHeight;
  TextEditingController get packageWidth => _state.packageWidth;
  TextEditingController get packageLength => _state.packageLength;
  TextEditingController get packageWeight => _state.packageWeight;
  String get accessCode => _state.accessCode;
  List<ListingEntity> get listings => _listings;

  // State delegation - Setters
  void setPost(PostEntity? value) {
    _post = value;
    AppLog.info('Post id ${post?.postID}');
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
    notifyListeners();
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
          await _onItemSubmit();
          break;
      }
    } catch (e) {
      AppLog.error('Error during submission: $e');
      // Show error to user
    } finally {
      setLoading(false);
    }
  }

  Future<bool> _validateForm(BuildContext context) async {
    // Basic validation
    if (title.text.isEmpty) {
      AppLog.error('Title is required');
      return false;
    }
    if (description.text.isEmpty) {
      AppLog.error('Description is required');
      return false;
    }
    if (price.text.isEmpty) {
      AppLog.error('Price is required');
      return false;
    }
    if (selectedCategory == null) {
      AppLog.error('Category is required');
      return false;
    }

    // Type-specific validation
    switch (listingType) {
      case ListingType.vehicle:
        if (!(vehicleKey.currentState?.validate() ?? false)) return false;
        break;
      case ListingType.clothAndFoot:
        if (!(clothesAndFootKey.currentState?.validate() ?? false))
          return false;
        break;
      case ListingType.property:
        if (!(propertyKey.currentState?.validate() ?? false)) return false;
        break;
      case ListingType.pets:
        if (!(petKey.currentState?.validate() ?? false)) return false;
        break;
      default:
        if (!(itemKey.currentState?.validate() ?? false)) return false;
        break;
    }

    return true;
  }

  // Submission methods
  Future<void> _onItemSubmit() async {
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
      currency: 'USD', // You might want to make this dynamic
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
  }

  Future<void> _onPetSubmit() async {
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
      currency: 'USD', // You might want to make this dynamic
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
  }

  Future<void> _onClothesAndFootSubmit() async {
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
      currency: 'USD',
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      brand: brand,
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
  }

  Future<void> _onFoodAndDrinkSubmit() async {
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
      currency: 'USD',
      category: selectedCategory,
      condition: condition,
      quantity: quantity.text,
      // availability: _availabilityManager.getAvailabilityData(),
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
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
      currency: 'USD',
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
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
      currency: 'USD',
    );

    final DataState<String> result = _post == null
        ? await _addListingUsecase(param)
        : await _editListingUsecase(param);

    _handleSubmissionResult(result);
  }

  void _handleSubmissionResult(DataState<String> result) {
    if (result is DataSuccess) {
      AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName, (_) => false);
      reset();
    } else if (result is DataFailer) {
      AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
    }
  }

  // Attachment methods
  Future<void> setImages(BuildContext context,
      {required AttachmentType type}) async {
    notifyListeners();
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

  void initializeForEdit(PostEntity post, List<ListingEntity> listings) {
    _post = post;
    _listings.clear();
    _listings.addAll(listings);

    if (listings.isNotEmpty) {
      title.text = post.title;
      description.text = post.description;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
