import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../post/data/models/meetup/availability_model.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../post/domain/entities/meetup/availability_entity.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../data/models/listing_model.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/sources/remote/dropdown_listing_api.dart';
import '../../data/sources/remote/listing_api.dart';
import '../../domain/entities/color_options_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecase/add_listing_usecase.dart';
import '../../domain/usecase/edit_listing_usecase.dart';
import '../params/add_listing_param.dart';
import '../params/get_categories_params.dart';
import '../widgets/property/add_property_tenure_type.dart';

class AddListingFormProvider extends ChangeNotifier {
  AddListingFormProvider(
    this._addlistingUSecase,
    this._editListingUsecase,
  );
  final AddListingUsecase _addlistingUSecase;
  final EditListingUsecase _editListingUsecase;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<AvailabilityEntity> _availability = DayType.values.map((DayType day) {
    return AvailabilityModel(
      day: day,
      isOpen: false,
      openingTime: '',
      closingTime: '',
    );
  }).toList();

  // Getter for availability list.
  List<AvailabilityEntity> get availability => _availability;

  // Toggle open status and update default times.
  void toggleOpen(DayType day, bool isOpen) {
    final int index =
        _availability.indexWhere((AvailabilityEntity e) => e.day == day);
    if (index != -1) {
      final AvailabilityEntity current = _availability[index];
      _availability[index] = current.copyWith(
        isOpen: isOpen,
        openingTime: isOpen ? '10:00 am' : '',
        closingTime: isOpen ? '10:00 pm' : '',
      );
      notifyListeners();
    }
  }

  // Set a new opening time.
  void setOpeningTime(DayType day, String time) {
    final int index =
        _availability.indexWhere((AvailabilityEntity e) => e.day == day);
    if (index != -1) {
      final AvailabilityEntity current = _availability[index];
      _availability[index] = current.copyWith(openingTime: time);
      notifyListeners();
    }
  }

  // Set a new closing time.
  void setClosingTime(DayType day, String time) {
    final int index =
        _availability.indexWhere((AvailabilityEntity e) => e.day == day);
    if (index != -1) {
      final AvailabilityEntity current = _availability[index];
      _availability[index] = current.copyWith(closingTime: time);
      notifyListeners();
    }
  }

  // Generate time slots in 30-minute increments.
  List<String> generateTimeSlots() {
    final List<String> slots = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
        slots.add(_formatTimeOfDay(time));
      }
    }
    return slots;
  }

  // Format TimeOfDay into a string like "10:00 am".
  String _formatTimeOfDay(TimeOfDay time) {
    final int hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hourOfPeriod:$minute $period';
  }

  // Parse a time string like "10:00 am" into TimeOfDay.
  TimeOfDay parseTimeString(String timeString) {
    try {
      final List<String> parts = timeString.split(RegExp(r'[: ]'));
      final int hour = int.parse(parts[0]) +
          ((parts[2].toLowerCase() == 'pm' && parts[0] != '12') ? 12 : 0);
      final int minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  // Validate that closing time is later than opening time.
  bool isClosingTimeValid(String openingTime, String closingTime) {
    final TimeOfDay open = parseTimeString(openingTime);
    final TimeOfDay close = parseTimeString(closingTime);
    return ((close.hour * 60 + close.minute) > (open.hour * 60 + open.minute));
  }

  // Update opening time and auto-adjust closing time if necessary.
  void updateOpeningTime(DayType day, String time) {
    setOpeningTime(day, time);
    // Get the current entity for the day.
    final AvailabilityEntity entity =
        availability.firstWhere((AvailabilityEntity e) => e.day == day);
    // If closing time is empty or not valid, adjust closing time automatically.
    if (entity.closingTime.isEmpty ||
        !isClosingTimeValid(time, entity.closingTime)) {
      final TimeOfDay parsedTime = parseTimeString(time);
      final TimeOfDay endTime = parsedTime.replacing(hour: parsedTime.hour + 1);
      setClosingTime(day, _formatTimeOfDay(endTime));
    }
  }

// Prepare the availability data for the API
  List<Map<String, dynamic>>? availabilityData;
  // This method will generate the availability data from your _availability list
  List<Map<String, dynamic>> getAvailabilityData() {
    return _availability
        .map((AvailabilityEntity model) => model.toJson())
        .toList();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  PostEntity? createPostFromFormData() {
    debugPrint('listing variables preview');
    return PostEntity(
        engineSize: double.tryParse(engineSize.text),
        mileageUnit: _selectedMileageUnit,
        energyRating: selectedEnergyRating,
        propertytype: '',
        transmission: '',
        updatedAt: DateTime.now(),
        listID: '',
        postID: '',
        businessID: LocalAuth.currentUser?.businessID,
        currency: LocalAuth.currentUser?.currency?.toUpperCase(),
        type: listingType ?? ListingType.items,
        listOfReviews: <double>[],
        collectionLatitude: 23,
        collectionLongitude: 123,
        createdAt: DateTime.now(),
        createdBy: LocalAuth.currentUser?.userID ?? '',
        currentLatitude: 32,
        currentLongitude: 323,
        sizeChartUrl: null,
        discounts: <DiscountEntity>[],
        hasDiscount: false,
        isActive: false,
        updatedBy: '',
        title: _title.text,
        description: _description.text,
        price: double.tryParse(_price.text) ?? 0.0,
        quantity: int.tryParse(_quantity.text) ?? 1,
        minOfferAmount: double.tryParse(_minimumOffer.text) ?? 0.0,
        localDelivery: int.tryParse(_localDeliveryFee.text) ?? 0,
        internationalDelivery:
            int.tryParse(_internationalDeliveryFee.text) ?? 0,
        accessCode: _accessCode,
        condition: _condition,
        acceptOffers: _acceptOffer,
        privacy: _privacy,
        deliveryType: _deliveryType,
        sizeColors: _sizeColorEntities,
        address: _location.text,
        categoryType: _selectedClothSubCategory,
        brand: _brand.text,
        make: _make,
        model: _model.text,
        year: int.tryParse(_year.text) ?? 0,
        mileage: int.tryParse(_mileage.text) ?? 0,
        emission: _emission,
        doors: int.tryParse(_doors.text) ?? 0,
        seats: int.tryParse(_seats.text) ?? 0,
        vehiclesCategory: _selectedVehicleCategory,
        bodyType: _selectedBodyType,
        fuelType: _selectedEnergyRating,
        interiorColor: _selectedVehicleColor,
        exteriorColor: _selectedVehicleColor,
        bedroom: int.tryParse(_bedroom.text) ?? 0,
        bathroom: int.tryParse(_bathroom.text) ?? 0,
        garden: _garden,
        parking: _parking,
        healthChecked: _healthChecked,
        wormAndFleaTreated: _wormAndFleaTreated,
        vaccinationUpToDate: _vaccinationUpToDate,
        readyToLeave: _time,
        age: _age,
        breed: _breed,
        petsCategory: _petCategory,
        propertyCategory: _selectedPropertySubCategory,
        tenureType: _tenureType,
        availability: _availability,
        collectionLocation: _selectedCollectionLocation,
        meetUpLocation: _selectedMeetupLocation,
        fileUrls: <AttachmentEntity>[]);
  }

  Future<void> reset() async {
    // Text fields
    _title.clear();
    _description.clear();
    _price.clear();
    _quantity.text = '1';
    _minimumOffer.clear();
    _localDeliveryFee.clear();
    _internationalDeliveryFee.clear();
    _engineSize.clear();
    _mileage.clear();
    _bedroom.clear();
    _bathroom.clear();
    _model.clear();
    _brand.clear();
    _seats.clear();
    _doors.clear();
    _emission = null;
    _location.clear();
    // File attachments
    _attachments = <PickedAttachment>[];
    // Core post data
    _post = null;
    _accessCode = '';
    _isDiscounted = false;

    // Booleans
    _garden = true;
    _parking = true;
    _animalFriendly = true;
    _acceptOffer = true;

    // Enums and types
    _age = null;
    _time = null;
    _condition = ConditionType.newC;
    _privacy = PrivacyType.public;
    _deliveryType = DeliveryType.paid;
    _listingType = null;
    _transmissionType = null;
    _make = null;

    // Nullable booleans
    _vaccinationUpToDate = null;
    _wormAndFleaTreated = null;
    _healthChecked = null;

    // Categories and selections
    _selectedCategory = null;
    _breed = null;
    _petCategory = null;
    _selectedBodyType = null;
    _selectedEnergyRating = null;
    _selectedMileageUnit = null;
    _selectedPropertyType = null;
    _selectedVehicleCategory = null;
    _selectedVehicleColor = null;
    _selectedMeetupLocation = null;
    _selectedCollectionLocation = null;
    // List data
    _sizeColorEntities = <SizeColorModel>[];

    // Strings
    _tenureType = 'freehold';
    _selectedPropertySubCategory = ListingType.property.cids.first;
    _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;

    // Reset discounts
    for (DiscountEntity element in _discounts) {
      element.discount = 0;
    }

    // Reset form keys
    _petKey.currentState?.reset();
    _itemKey.currentState?.reset();
    _vehicleKey.currentState?.reset();
    _propertyKey.currentState?.reset();
    _foodAndDrinkKey.currentState?.reset();
    _clothesAndFootKey.currentState?.reset();

    debugPrint('listing variables reset');

    notifyListeners();
  }

  Future<void> updateVariables() async {
    // Category and access
    _selectedCategory = findCategoryByAddress(_listings, post?.address ?? '');
    _accessCode = post?.accessCode ?? '';
    // Age and pet-related
    _age = post?.age;
    _animalFriendly = _animalFriendly;
    _vaccinationUpToDate = post?.vaccinationUpToDate;
    _wormAndFleaTreated = post?.wormAndFleaTreated;
    _healthChecked = post?.healthChecked;
    _time = post?.readyToLeave;
    // Availability
    _availability = post?.availability ?? <AvailabilityEntity>[];
    // Locations
    _selectedMeetupLocation = post?.meetUpLocation;
    _selectedCollectionLocation = post?.collectionLocation;
    _location.text = post?.meetUpLocation?.address ?? '';
    // Property details
    _bathroom.text = post?.bathroom.toString() ?? '0';
    _bedroom.text = post?.bedroom.toString() ?? '0';
    _garden = post?.garden ?? true;
    _parking = post?.parking ?? true;
    _selectedPropertySubCategory = post?.propertyCategory.toString() ?? '';
    _selectedPropertyType = post?.propertytype;
    _tenureType = post?.tenureType ?? '';
    // Product details
    _title.text = post?.title ?? '';
    _description.text = post?.description ?? '';
    _price.text = post?.price.toString() ?? '';
    _quantity.text = post?.quantity.toString() ?? '1';
    _minimumOffer.text = post?.minOfferAmount.toString() ?? '';
    _isDiscounted = post?.hasDiscount ?? false;
    // Brand/Model/Make
    _brand.text = post?.brand ?? '';
    _make = post?.make.toString() ?? '';
    _model.text = post?.model.toString() ?? '';
    // Vehicle details
    _engineSize.text = post?.engineSize.toString() ?? '';
    _mileage.text = post?.mileage.toString() ?? '';
    _selectedMileageUnit = post?.mileageUnit;
    _emission = post?.emission ?? '';
    _seats.text = post?.seats.toString() ?? '';
    _doors.text = post?.doors.toString() ?? '';
    _year.text = post?.year.toString() ?? '';
    _transmissionType = post?.transmission ?? '';
    _selectedVehicleCategory = post?.vehiclesCategory;
    _selectedVehicleColor = post?.vehiclesCategory;
    _selectedBodyType = post?.bodyType ?? '';

    // Delivery & fees
    _deliveryType = post?.deliveryType ?? DeliveryType.paid;
    _localDeliveryFee.text = post?.localDelivery.toString() ?? '';
    _internationalDeliveryFee.text =
        post?.internationalDelivery.toString() ?? '';

    // Listing, privacy, and condition
    _listingType = ListingType.fromJson(post?.listID);
    _privacy = post?.privacy ?? PrivacyType.supporters;
    _condition = post?.condition ?? ConditionType.newC;

    // Discounts
    debugPrint(post?.discounts.toString());
    for (DiscountEntity element in _discounts) {
      final DiscountEntity? matching = post?.discounts.firstWhere(
        (DiscountEntity e) => e.quantity == element.quantity,
        orElse: () => DiscountEntity(quantity: element.quantity, discount: 5),
      );
      element.discount = matching?.discount ?? 0;
    }

    // Clothes and sizing
    _selectedClothSubCategory = post?.categoryType ?? '';
    _selectedEnergyRating = post?.energyRating;
    _sizeColorEntities = post?.sizeColors ?? <SizeColorEntity>[];
    debugPrint('listing variables update variables');
  }

  Future<void> submit(BuildContext context) async {
    if (_attachments.isEmpty && (_post?.fileUrls.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please_add_at_least_one_photo_or_video'.tr()),
      ));
      return;
    }
    if (selectedCategory == null &&
        (listingType == ListingType.items ||
            listingType == ListingType.clothAndFoot ||
            listingType == ListingType.foodAndDrink)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('select_category'.tr()),
      ));
      return;
    }
    setLoading(true);
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
    setLoading(false);
  }

  Future<void> _onItemSubmit() async {
    if (!(_itemKey.currentState?.validate() ?? false)) return;
    try {
      final AddListingParam param = AddListingParam(
        accessCode: _accessCode,
        postID: post?.postID ?? '',
        oldAttachments: post?.fileUrls,
        currency: _post == null
            ? LocalAuth.currentUser?.currency?.toUpperCase()
            : null,
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        quantity: quantity.text,
        discount: isDiscounted,
        discounts: discounts,
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        deliveryType: deliveryType,
        localDeliveryAmount: _localDeliveryFee.text,
        internationalDeliveryAmount: _internationalDeliveryFee.text,
        listingType: listingType ?? ListingType.items,
        category: _selectedCategory,
        currentLatitude: 12234,
        currentLongitude: 123456,
        collectionLocation: selectedCollectionLocation,
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddListingProvider.onvehicleSubmit - else');
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> _onClothesAndFootSubmit() async {
    if (!(clothesAndFootKey.currentState?.validate() ?? false)) return;
    try {
      final AddListingParam param = AddListingParam(
          postID: post?.postID ?? '',
          oldAttachments: post?.fileUrls,
          currency: _post == null ? LocalAuth.currentUser?.currency : null,
          title: title.text,
          description: description.text,
          attachments: attachments,
          collectionLocation: selectedmeetupLocation,
          price: price.text,
          quantity: quantity.text,
          discount: isDiscounted,
          discounts: discounts,
          condition: condition,
          acceptOffer: acceptOffer,
          minOfferAmount: minimumOffer.text,
          privacyType: _privacy,
          deliveryType: deliveryType,
          localDeliveryAmount: _localDeliveryFee.text,
          internationalDeliveryAmount: _internationalDeliveryFee.text,
          listingType: ListingType.clothAndFoot,
          category: _selectedCategory,
          currentLatitude: 1234,
          currentLongitude: 1234,
          brand: brand.text,
          sizeColor: _sizeColorEntities,
          type: selectedClothSubCategory);
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> _onVehicleSubmit() async {
    if (!(_vehicleKey.currentState?.validate() ?? false)) return;
    getAvailabilityData();
    try {
      debugPrint(post?.postID);
      final AddListingParam param = AddListingParam(
          postID: post?.postID ?? '',
          oldAttachments: post?.fileUrls,
          availbility: jsonEncode(
            _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
          ),
          engineSize: engineSize.text,
          meetUpLocation: _selectedMeetupLocation,
          mileage: mileage.text,
          currency: _post == null ? LocalAuth.currentUser?.currency : null,
          title: title.text,
          description: description.text,
          attachments: attachments,
          price: price.text,
          discount: isDiscounted,
          condition: condition,
          acceptOffer: acceptOffer,
          minOfferAmount: minimumOffer.text,
          collectionLocation: selectedmeetupLocation,
          privacyType: _privacy,
          deliveryType: deliveryType,
          listingType: listingType ?? ListingType.vehicle,
          category: _selectedCategory,
          type: selectedClothSubCategory,
          bodyType: _selectedBodyType,
          color: _selectedVehicleColor,
          doors: doors.text,
          emission: _emission,
          make: _make,
          model: model.text,
          seats: seats.text,
          year: year.text,
          vehicleCategory: _selectedVehicleCategory.toString(),
          currentLatitude: 1234,
          currentLongitude: 1234,
          milageUnit: _selectedMileageUnit,
          transmission: transmissionType);
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AddListingProvider.onvehicleSubmit - else');
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> _onFoodAndDrinkSubmit() async {
    if (!(_foodAndDrinkKey.currentState?.validate() ?? false)) return;
    try {
      final AddListingParam param = AddListingParam(
          postID: post?.postID ?? '',
          oldAttachments: post?.fileUrls,
          deliveryType: deliveryType,
          quantity: quantity.text,
          currency: _post == null ? LocalAuth.currentUser?.currency : null,
          title: title.text,
          description: description.text,
          collectionLocation: selectedmeetupLocation,
          attachments: attachments,
          price: price.text,
          discount: isDiscounted,
          discounts: _discounts,
          condition: condition,
          acceptOffer: acceptOffer,
          minOfferAmount: minimumOffer.text,
          privacyType: _privacy,
          listingType: listingType ?? ListingType.foodAndDrink,
          category: _selectedCategory,
          currentLatitude: 1234,
          currentLongitude: 1234,
          localDeliveryAmount: _localDeliveryFee.text,
          internationalDeliveryAmount: _internationalDeliveryFee.text);
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> _onPropertySubmit() async {
    if (!(_propertyKey.currentState?.validate() ?? false)) return;

    getAvailabilityData();
    try {
      final AddListingParam param = AddListingParam(
        postID: post?.postID ?? '',
        oldAttachments: post?.fileUrls,
        currency: _post == null ? LocalAuth.currentUser?.currency : null,
        animalFriendly: animalFriendly.toString(),
        parking: parking.toString(),
        propertyType: _selectedPropertyType,
        bathrooms: _bathroom.text,
        bedrooms: _bedroom.text,
        energyrating: _selectedEnergyRating,
        garden: garden.toString(),
        tenureType: tenureType,
        propertyCategory: _selectedPropertySubCategory,
        availbility: jsonEncode(
          _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
        ),
        meetUpLocation: _selectedMeetupLocation,
        collectionLocation: _selectedCollectionLocation,
        mileage: mileage.text,
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        discount: isDiscounted,
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        deliveryType: deliveryType,
        listingType: listingType ?? ListingType.vehicle,
        category: _selectedCategory,
        currentLatitude: 1234,
        currentLongitude: 1234,
        milageUnit: _selectedMileageUnit,
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> _onPetSubmit() async {
    if (!(_petKey.currentState?.validate() ?? false)) return;
    try {
      debugPrint(post?.meetUpLocation?.id);
      final AddListingParam param = AddListingParam(
        postID: post?.postID ?? '',
        oldAttachments: post?.fileUrls,
        accessCode: _accessCode,
        age: age ?? '',
        breed: selectedCategory?.title ?? '',
        healthChecked: _healthChecked,
        petsCategory: _petCategory,
        wormAndFleaTreated: _wormAndFleaTreated,
        vaccinationUpToDate: _vaccinationUpToDate,
        readyToLeave: _time,
        quantity: _quantity.text,
        currency: _post == null ? LocalAuth.currentUser?.currency : null,
        animalFriendly: animalFriendly.toString(),
        parking: parking.toString(),
        propertyType: _selectedPropertyType,
        availbility: jsonEncode(
          _availability.map((AvailabilityEntity e) => e.toJson()).toList(),
        ),
        meetUpLocation: _selectedMeetupLocation,
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        deliveryType: deliveryType,
        collectionLocation: selectedmeetupLocation,
        listingType: listingType ?? ListingType.pets,
        category: _selectedCategory,
        currentLatitude: 12234,
        currentLongitude: 123456,
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = _post == null
          ? await _addlistingUSecase(param)
          : await _editListingUsecase(param);
      if (result is DataSuccess) {
        AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (_) => false);
        reset();
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {}
  }

  Future<void> fetchDropdownListings(String endpoint) async {
    _isDropdownLoading = true;
    notifyListeners();
    try {
      await DropDownListingAPI()
          .fetchAndStore(endpoint)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Error fetching dropdown listings: $e');
      // Optionally handle error
    } finally {
      _isDropdownLoading = false;
      notifyListeners();
    }
  }

  void setPost(PostEntity? value) {
    _post = value;
    AppLog.info('Post id ${post?.postID}');
  }

  /// Setter
  void setListingType(ListingType? value) {
    _listingType = value;
    notifyListeners();
  }

  void setSelectedCategory(SubCategoryEntity? value) {
    if (value == null) return;
    _selectedCategory = value;
    notifyListeners();
  }

  void setIsDiscount(bool value) {
    _isDiscounted = value;
    notifyListeners();
  }

  void setDiscounts(DiscountEntity value) {
    try {
      _discounts
          .where((DiscountEntity element) {
            return element.quantity == value.quantity;
          })
          .first
          .discount = value.discount;
      notifyListeners();
    } catch (e) {
      AppLog.error(
        'Not Discount Found with Quantity: ${value.quantity}',
        name: 'AddListingFormProvider.setDiscounts - catch',
      );
    }
  }

  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment> selectedMedia =
        _attachments.where((PickedAttachment element) {
      return element.selectedMedia != null;
    }).toList();
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 10,
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

  void removePickedAttachment(PickedAttachment attachment) {
    _attachments.remove(attachment);
    notifyListeners();
  }

  void removeAttachmentEntity(AttachmentEntity attachment) {
    _post?.fileUrls.remove(attachment);
    notifyListeners();
  }

  void setCondition(ConditionType value) {
    _condition = value;
    notifyListeners();
  }

  void setAcceptOffer(bool value) {
    _acceptOffer = value;
    notifyListeners();
  }

  void setPrivacy(PrivacyType value) {
    _privacy = value;
    notifyListeners();
  }

  void incrementQuantity() {
    final int value = int.parse(_quantity.text);
    _quantity.text = (value + 1).toString();
    notifyListeners();
  }

  void decrementQuantity() {
    final int value = int.parse(_quantity.text);
    if (value > 1) {
      _quantity.text = (value - 1).toString();
      notifyListeners();
    }
  }

  void setDeliveryType(DeliveryType? value) {
    if (value == null) return;
    _deliveryType = value;
    notifyListeners();
  }

  void setCollectionLocation(LocationModel value) {
    _selectedCollectionLocation = value;
  }

  void setMeetupLocation(LocationModel value) {
    _selectedMeetupLocation = value;
  }

  Future<void> fetchCategories(String listID, String listIdType) async {
    final GetCategoriesParams params =
        GetCategoriesParams(listId: listID, listIdType: listIdType);
    _listings = await ListingAPI().listing(params);
  }

  // Cloth and Foot
  void setSelectedClothSubCategory(String value) {
    _selectedClothSubCategory = value;
    _selectedCategory = null;
    notifyListeners();
  }

  void setSelectedPropertySubCategory(String value) {
    _selectedClothSubCategory = value;
    notifyListeners();
  }

  // Vehicle
  void setTransmissionType(String? value) {
    _transmissionType = value;
    notifyListeners();
  }

  void setFuelType(String? value) {
    _fuelType = value;
    notifyListeners();
  }

  void setMileageUnit(String? unit) {
    _selectedMileageUnit = unit;
    notifyListeners();
  }

  void setVehicleColor(String value) {
    _selectedVehicleColor = value;
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

  // Property
  void setGarden(bool? value) {
    if (value == null) return;
    _garden = value;
    notifyListeners();
  }

  void setParking(bool? value) {
    if (value == null) return;
    _parking = value;
    notifyListeners();
  }

  void setAnimalFriendly(bool? value) {
    if (value == null) return;
    _animalFriendly = value;
    notifyListeners();
  }

  void setPropertyType(String? value) {
    _selectedPropertyType = value;
    notifyListeners();
  }

  void setEnergyRating(String? value) {
    _selectedEnergyRating = value;
    notifyListeners();
  }

  void setSelectedTenureType(String value) {
    _tenureType = value;
    notifyListeners();
  }

  void setTime(String? value) {
    if (value == null) return;
    _time = value;
    notifyListeners();
  }

  void setAccessCode(String? value) {
    if (value == null) return;
    _accessCode = value;
    // notifyListeners();
  }

// pets
  void setPetCategory(String? category) {
    _petCategory = category;
    notifyListeners();
  }

  void setPetBreed(String? value) {
    _breed = value;
    notifyListeners();
  }

  void setPetBreeds(String category) {
    _petCategory = category;
    notifyListeners();
  }

  void setVaccinationUpToDate(bool? value) {
    _vaccinationUpToDate = value;
    notifyListeners();
  }

  void setWormFleeTreated(bool? value) {
    _wormAndFleaTreated = value;
    notifyListeners();
  }

  void setHealthChecked(bool? value) {
    _healthChecked = value;
    notifyListeners();
  }

  void setAge(String? value) {
    if (value == null) return;
    _age = value;
    notifyListeners();
  }

  void setemissionType(String? value) {
    _emission = value;
    notifyListeners();
  }

  void seteMake(String? value) {
    _make = value;
    notifyListeners();
  }
//?

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void addOrUpdateSizeColorQuantity({
    required String size,
    required String color,
    required int quantity,
  }) {
    final int sizeIndex =
        _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);

    if (sizeIndex != -1) {
      final SizeColorEntity existingSize = _sizeColorEntities[sizeIndex];

      final int colorIndex =
          existingSize.colors.indexWhere((ColorEntity c) => c.code == color);

      if (colorIndex != -1) {
        // Update quantity for existing color
        existingSize.colors[colorIndex] =
            ColorEntity(code: color, quantity: quantity);
      } else {
        // Add new color to existing size
        existingSize.colors.add(ColorEntity(code: color, quantity: quantity));
        debugPrint(existingSize.colors.first.code);
      }

      _sizeColorEntities[sizeIndex] = SizeColorModel(
        value: existingSize.value,
        id: existingSize.id,
        colors: existingSize.colors,
      );
    } else {
      // Add new size with color
      _sizeColorEntities.add(
        SizeColorModel(
          value: size.toString(),
          id: size.toString(),
          colors: <ColorEntity>[
            ColorEntity(code: color.toString(), quantity: quantity),
          ],
        ),
      );
    }
    notifyListeners();
  }

  /// Removes a specific color from a specific size.
  /// If that size has no more colors left, the size entry is removed.
  void removeColorFromSize({
    required String size,
    required String color,
  }) {
    final int sizeIndex =
        _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);
    if (sizeIndex != -1) {
      _sizeColorEntities[sizeIndex]
          .colors
          .removeWhere((ColorEntity c) => c.code == color);

      // If no colors left, remove the size entry as well
      if (_sizeColorEntities[sizeIndex].colors.isEmpty) {
        _sizeColorEntities.removeAt(sizeIndex);
      }

      notifyListeners();
    }
  }

  /// Clears all size-color-quantity data.

  // Future<List<ColorOptionEntity>> colorOptions() async {
  //   final String jsonString =
  //       await rootBundle.loadString('assets/jsons/colors.json');
  //   final Map<String, dynamic> colorsMap = jsonDecode(jsonString);
  //   final Map<String, dynamic> colors = colorsMap['colors'];
  //   return colors.entries.map((MapEntry<String, dynamic> entry) {
  //     return ColorOptionModel.fromJson(entry.value);
  //   }).toList();
  // }

  // // Load colors into the provider
  // Future<void> fetchColors() async {
  //   _colors = await colorOptions();
  //   notifyListeners();
  // }

  /// Getter
  ListingType? get listingType => _listingType ?? ListingType.items;
  bool get isDropdownLoading => _isDropdownLoading;
  SubCategoryEntity? get selectedCategory => _selectedCategory;
  String? get selectedVehicleCategory => _selectedVehicleCategory;
  PostEntity? get post => _post;

  bool get isDiscounted => _isDiscounted;
  List<DiscountEntity> get discounts => _discounts;
  List<SizeColorEntity> get sizeColorEntities => _sizeColorEntities;
  LocationEntity? get selectedmeetupLocation => _selectedMeetupLocation;
  LocationEntity? get selectedCollectionLocation => _selectedCollectionLocation;

  //
  List<PickedAttachment> get attachments => _attachments;
  ConditionType get condition => _condition;
  bool get acceptOffer => _acceptOffer;
  PrivacyType get privacy => _privacy;
  DeliveryType get deliveryType => _deliveryType;
  // Cloth and Foot
  String get selectedClothSubCategory => _selectedClothSubCategory;
  List<ColorOptionEntity> get colors => _colors;
  String? get selectedVehicleColor => _selectedVehicleColor;
  // Vehicle
  String? get transmissionType => _transmissionType;
  String? get fuelTYpe => _fuelType;
  String? get selectedMileageUnit => _selectedMileageUnit;
  TextEditingController get engineSize => _engineSize;
  TextEditingController get mileage => _mileage;
  String? get selectedBodyType => _selectedBodyType;
  String? get make => _make;
  TextEditingController get model => _model;
  TextEditingController get year => _year;
  String? get emission => _emission;
  TextEditingController get doors => _doors;
  TextEditingController get seats => _seats;
  TextEditingController get location => _location;
  // Property
  TextEditingController get bedroom => _bedroom;
  TextEditingController get bathroom => _bathroom;
  String get tenureType => _tenureType;
  String? get selectedPropertySubCategory => _selectedPropertySubCategory;
  String? get selectedPropertyType => _selectedPropertyType;
  bool get garden => _garden;
  bool get parking => _parking;
  bool get animalFriendly => _animalFriendly;
  String? get selectedEnergyRating => _selectedEnergyRating;
  // Pet
  String? get age => _age;
  String? get petCategory => _petCategory;
  bool? get healthChecked => _healthChecked;
  String? get breed => _breed;
  // bool? get petsCategory => _petsCategory;
  bool? get wormAndFleaTreated => _wormAndFleaTreated;
  bool? get vaccinationUpToDate => _vaccinationUpToDate;
  String? get time => _time;
  bool get isLoading => _isLoading;
  //
  TextEditingController get title => _title;
  TextEditingController get description => _description;
  TextEditingController get brand => _brand;
  TextEditingController get price => _price;
  TextEditingController get quantity => _quantity;
  TextEditingController get minimumOffer => _minimumOffer;
  TextEditingController get localDeliveryFee => _localDeliveryFee;
  TextEditingController get internationalDeliveryFee =>
      _internationalDeliveryFee;

  String get accessCode => _accessCode;

  GlobalKey<FormState> get itemKey => _itemKey;
  GlobalKey<FormState> get clothesAndFootKey => _clothesAndFootKey;
  GlobalKey<FormState> get vehicleKey => _vehicleKey;
  GlobalKey<FormState> get foodAndDrinkKey => _foodAndDrinkKey;
  GlobalKey<FormState> get propertyKey => _propertyKey;
  GlobalKey<FormState> get petKey => _petKey;
  List<ListingEntity> get listings => _listings;

  //
  /// Controller
  List<ListingEntity> _listings = <ListingEntity>[];
  bool _isDropdownLoading = false;
  PostEntity? _post;
  ListingType? _listingType;
  SubCategoryEntity? _selectedCategory;
  String? _selectedVehicleCategory;
  bool _isDiscounted = false;
  final List<DiscountEntity> _discounts = <DiscountEntity>[
    DiscountEntity(quantity: 2, discount: 0),
    DiscountEntity(quantity: 3, discount: 0),
    DiscountEntity(quantity: 5, discount: 0),
  ];
  // Selected Category
  SubCategoryEntity? findCategoryByAddress(
    List<ListingEntity> listings,
    String address,
  ) {
    for (ListingEntity listing in listings) {
      SubCategoryEntity? result =
          _findCategoryInSubCategories(listing.subCategory, address);
      if (result != null) {
        return result;
      }
    }
    AppLog.info('No matching category found for address: $address',
        name: 'AddListingFormProvider - findCategoryByAddress');
    return null;
  }

  SubCategoryEntity? _findCategoryInSubCategories(
    List<SubCategoryEntity> subCategories,
    String address,
  ) {
    for (SubCategoryEntity subCategory in subCategories) {
      if (subCategory.address == address) {
        AppLog.info('Match found: ${subCategory.toString()}',
            name: 'AddListingFormProvider - findCategoryByAddress');
        return subCategory; // Return the matching subCategory
      }

      // If this subcategory has nested subcategories, recurse through them
      if (subCategory.subCategory.isNotEmpty) {
        SubCategoryEntity? result =
            _findCategoryInSubCategories(subCategory.subCategory, address);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  List<SizeColorEntity> _sizeColorEntities = <SizeColorModel>[];
  //
  ConditionType _condition = ConditionType.newC;
  bool _acceptOffer = true;
  PrivacyType _privacy = PrivacyType.public;
  DeliveryType _deliveryType = DeliveryType.paid;
  LocationEntity? _selectedMeetupLocation;
  LocationEntity? _selectedCollectionLocation;
  // Cloth and Foot
  String _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;
  final List<ColorOptionEntity> _colors = <ColorOptionEntity>[];
  // Vehicle
  String? _transmissionType;
  String? _fuelType;
  final TextEditingController _engineSize = TextEditingController();
  final TextEditingController _mileage = TextEditingController();
  String? _make;
  final TextEditingController _model = TextEditingController();
  final TextEditingController _year = TextEditingController();
  String? _emission;
  final TextEditingController _doors = TextEditingController();
  final TextEditingController _seats = TextEditingController();
  final TextEditingController _location = TextEditingController();
  String? _selectedBodyType;
  String? _selectedVehicleColor;
  String? _selectedMileageUnit;
  // Property
  final TextEditingController _bedroom = TextEditingController();
  final TextEditingController _bathroom = TextEditingController();
  String _tenureType = TenureType.freehold.value;
  String _selectedPropertySubCategory = ListingType.property.cids.first;
  String? _selectedEnergyRating;
  String? _selectedPropertyType;

  bool _garden = true;
  bool _parking = true;
  bool _animalFriendly = true;
  // Pet
  String? _petCategory;
  bool? _healthChecked;
  String? _breed;
  // bool _petsCategory;
  bool? _wormAndFleaTreated;
  bool? _vaccinationUpToDate;
  String? _age;
  String? _time;
  bool _isLoading = false;
  //
  List<PickedAttachment> _attachments = <PickedAttachment>[];
  final TextEditingController _title = TextEditingController(
    text: kDebugMode ? 'Test Title' : '',
  );
  final TextEditingController _description = TextEditingController(
    text: kDebugMode ? 'Test Description' : '',
  );
  final TextEditingController _price = TextEditingController(
    text: kDebugMode ? '100' : '',
  );
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _quantity = TextEditingController(text: '1');
  final TextEditingController _minimumOffer = TextEditingController(
    text: kDebugMode ? '50' : '',
  );
  final TextEditingController _localDeliveryFee = TextEditingController();
  final TextEditingController _internationalDeliveryFee =
      TextEditingController();
  String _accessCode = '';
  // Form State
  final GlobalKey<FormState> _itemKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _clothesAndFootKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _vehicleKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _foodAndDrinkKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _propertyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _petKey = GlobalKey<FormState>();

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
