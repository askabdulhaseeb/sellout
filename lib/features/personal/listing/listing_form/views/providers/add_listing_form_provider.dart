import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/listing/pet/age_time_type.dart';
import '../../../../../../core/enums/listing/pet/pet_categories.dart';
import '../../../../../../core/enums/listing/vehicle/transmission_type.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../explore/domain/entities/location_name_entity.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../post/data/models/meetup/availability_model.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../data/models/color_option_model.dart';
import '../../domain/entities/color_options_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecase/add_listing_usecase.dart';
import '../params/add_listing_param.dart';

class AddListingFormProvider extends ChangeNotifier {
  AddListingFormProvider(
    this._addlistingUSecase,
  );
  final AddListingUsecase _addlistingUSecase;
/////////////////////////////////////////////////////////////////////////////////////////////

  final List<AvailabilityModel> _availability =
      DayType.values.map((DayType day) {
    return AvailabilityModel(
      day: day,
      isOpen: false,
      openingTime: '',
      closingTime: '',
    );
  }).toList();

  // Getter for availability list.
  List<AvailabilityModel> get availability => _availability;

  // Toggle open status and update default times.
  void toggleOpen(DayType day, bool isOpen) {
    final int index =
        _availability.indexWhere((AvailabilityModel e) => e.day == day);
    if (index != -1) {
      final AvailabilityModel current = _availability[index];
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
        _availability.indexWhere((AvailabilityModel e) => e.day == day);
    if (index != -1) {
      final AvailabilityModel current = _availability[index];
      _availability[index] = current.copyWith(openingTime: time);
      notifyListeners();
    }
  }

  // Set a new closing time.
  void setClosingTime(DayType day, String time) {
    final int index =
        _availability.indexWhere((AvailabilityModel e) => e.day == day);
    if (index != -1) {
      final AvailabilityModel current = _availability[index];
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
    final AvailabilityModel entity =
        availability.firstWhere((AvailabilityModel e) => e.day == day);
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
        .map((AvailabilityModel model) => model.toJson())
        .toList();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  LocationNameEntity? _selectedLocation;
  Future<void> submit(BuildContext context) async {
    if (_attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please add at least one Photo or Video'),
      ));
      return;
    }
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

  Future<void> reset() async {
    _title.clear();
    _description.clear();
    _price.clear();
    _quantity.clear();
    _minimumOffer.clear();
    _localDeliveryFee.clear();
    _internationalDeliveryFee.clear();
    _accessCode = '';
    _engineSize.clear();
    _mileage.clear();
    _bedroom.clear();
    _bathroom.clear();
    _garden = true;
    _parking = true;
    _animalFriendly = true;
    _age = null;
    _time = AgeTimeType.readyToLeave;
    _condition = ConditionType.newC;
    _acceptOffer = true;
    _privacy = PrivacyType.public;
    _deliveryType = DeliveryType.paid;
    _isDiscounted = false;
    for (DiscountEntity element in _discounts) {
      element.discount = 0;
    }
    notifyListeners();
  }

  Future<void> _onItemSubmit() async {
    if (!(_itemKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    try {
      final AddListingParam param = AddListingParam(
        businessID: LocalAuth.currentUser?.businessID,
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        quantity: quantity.text,
        discount: isDiscounted,
        discount2Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 2)
            .discount
            .toString(),
        discount3Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 3)
            .discount
            .toString(),
        discount5Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 5)
            .discount
            .toString(),
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        deliveryType: deliveryType,
        localDeliveryAmount: _localDeliveryFee.text,
        internationalDeliveryAmount: _internationalDeliveryFee.text,
        listingType: listingType ?? ListingType.items,
        category: _selectedCategory,
        currency: LocalAuth.currentUser?.currency ?? '',
        currentLatitude: '12234',
        currentLongitude: '123456',
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = await _addlistingUSecase(param);
      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
    setLoading(false);
  }

  Future<void> _onClothesAndFootSubmit() async {
    if (!(_clothesAndFootKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    try {
      final AddListingParam param = AddListingParam(
          businessID: LocalAuth.currentUser?.businessID,
          title: title.text,
          description: description.text,
          attachments: attachments,
          price: price.text,
          quantity: quantity.text,
          discount: isDiscounted,
          discount2Items: _discounts
              .firstWhere((DiscountEntity e) => e.quantity == 2)
              .discount
              .toString(),
          discount3Items: _discounts
              .firstWhere((DiscountEntity e) => e.quantity == 3)
              .discount
              .toString(),
          discount5Items: _discounts
              .firstWhere((DiscountEntity e) => e.quantity == 5)
              .discount
              .toString(),
          condition: condition,
          acceptOffer: acceptOffer,
          minOfferAmount: minimumOffer.text,
          privacyType: _privacy,
          deliveryType: deliveryType,
          localDeliveryAmount: _localDeliveryFee.text,
          internationalDeliveryAmount: _internationalDeliveryFee.text,
          listingType: ListingType.clothAndFoot,
          category: _selectedCategory,
          currency: LocalAuth.currentUser?.currency?.toUpperCase() ?? '',
          currentLatitude: '12234',
          currentLongitude: '123456',
          brand: brand.text,
          sizeColor: _sizeColorEntities
              .map((SizeColorModel e) =>
                  SizeColorModel(value: e.value, colors: e.colors, id: e.id))
              .toList(),
          type: selectedClothSubCategory);
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = await _addlistingUSecase(param);
      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _onVehicleSubmit() async {
    if (!(_vehicleKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    getAvailabilityData();

    try {
      final AddListingParam param = AddListingParam(
        availbility: jsonEncode(
          _availability.map((AvailabilityModel e) => e.toJson()).toList(),
        ),
        engineSize: engineSize.text,
        meetUpLocation: LocationModel(
                address: selectedLocation?.description,
                id: selectedLocation?.placeId,
                title: selectedLocation?.structuredFormatting.mainText,
                url: '',
                latitude: 1234,
                longitude: 678)
            .toJson(),
        mileage: mileage.text,
        businessID: LocalAuth.currentUser?.businessID,
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
        currency: LocalAuth.currentUser?.currency ?? '',
        type: selectedClothSubCategory,
        bodyType: bodytype.text,
        color: _selectedVehicleColor,
        doors: doors.text,
        emission: emission.text,
        make: make.text,
        model: model.text,
        seats: seats.text,
        year: year.text,
        vehicleCategory: 'car',
        currentLatitude: '12234',
        currentLongitude: '123456',
        milageUnit: 'km',
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = await _addlistingUSecase(param);
      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _onFoodAndDrinkSubmit() async {
    if (!(_foodAndDrinkKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    try {
      final AddListingParam param = AddListingParam(
        deliveryType: deliveryType,
        quantity: quantity.text,
        businessID: LocalAuth.currentUser?.businessID,
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        discount: isDiscounted,
        discount2Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 2)
            .discount
            .toString(),
        discount3Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 3)
            .discount
            .toString(),
        discount5Items: _discounts
            .firstWhere((DiscountEntity e) => e.quantity == 5)
            .discount
            .toString(),
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        listingType: ListingType.foodAndDrink,
        category: _selectedCategory,
        currency: LocalAuth.currentUser?.currency ?? '',
      );
      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());
      final DataState<String> result = await _addlistingUSecase(param);
      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _onPropertySubmit() async {
    if (!(_propertyKey.currentState?.validate() ?? false)) return;

    setLoading(true);
    getAvailabilityData();
    try {
      final AddListingParam param = AddListingParam(
        businessID: LocalAuth.currentUser?.businessID ?? 'null',
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
          _availability.map((AvailabilityModel e) => e.toJson()).toList(),
        ),
        meetUpLocation: LocationModel(
          address: selectedLocation?.description ?? '',
          id: selectedLocation?.placeId ?? '',
          title: selectedLocation?.structuredFormatting.mainText ?? '',
          url: 'www.testurl.com',
          latitude: 1,
          longitude: 1,
        ).toJsonidurlkeys(),
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
        currency: LocalAuth.currentUser?.currency ?? '',
        currentLatitude: '12234',
        currentLongitude: '123456',
        milageUnit: 'km',
      );

      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());

      final DataState<String> result = await _addlistingUSecase(param);

      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _onPetSubmit() async {
    if (!(_petKey.currentState?.validate() ?? false)) return;
    try {
      final AddListingParam param = AddListingParam(
        accessCode: _accessCode,
        age: age?.json,
        breed: _breed.text,
        healthChecked: _healthChecked,
        petsCategory: _petCategory?.json,
        wormAndFleaTreated: _wormAndFleaTreated,
        vaccinationUpToDate: _vaccinationUpToDate,
        readyToLeave: _time?.json,
        quantity: quantity.text,
        businessID: LocalAuth.currentUser?.businessID ?? 'null',
        animalFriendly: animalFriendly.toString(),
        parking: parking.toString(),
        propertyType: _selectedPropertyType,
        availbility: jsonEncode(
          _availability.map((AvailabilityModel e) => e.toJson()).toList(),
        ),
        meetUpLocation: LocationModel(
          address: selectedLocation?.description ?? '',
          id: selectedLocation?.placeId ?? '',
          title: selectedLocation?.structuredFormatting.mainText ?? '',
          url: 'www.testurl.com',
          latitude: 1,
          longitude: 1,
        ).toJsonidurlkeys(),
        title: title.text,
        description: description.text,
        attachments: attachments,
        price: price.text,
        condition: condition,
        acceptOffer: acceptOffer,
        minOfferAmount: minimumOffer.text,
        privacyType: _privacy,
        deliveryType: deliveryType,
        listingType: listingType ?? ListingType.pets,
        category: _selectedCategory,
        currency: LocalAuth.currentUser?.currency ?? '',
        currentLatitude: '12234',
        currentLongitude: '123456',
        milageUnit: 'km',
      );

      debugPrint(param.toMap().toString());
      debugPrint(sizeColorEntities.toString());

      final DataState<String> result = await _addlistingUSecase(param);

      if (result is DataSuccess) {
        AppLog.info('Listing success: ${result.data}');
      } else if (result is DataFailer) {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr());
      }
    } catch (e) {
      AppLog.error('$e');
    } finally {
      setLoading(false);
    }
  }

  //
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

  void removeAttachment(PickedAttachment attachment) {
    _attachments.remove(attachment);
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

  void setSelectedLocation(LocationNameEntity value) {
    _selectedLocation = value;
  }

  // Cloth and Foot
  void setSelectedClothSubCategory(String value) {
    _selectedClothSubCategory = value;
    notifyListeners();
  }

  void setSelectedPropertySubCategory(String value) {
    _selectedClothSubCategory = value;
    notifyListeners();
  }

  // Vehicle
  void setTransmissionType(TransmissionType? value) {
    if (value == null) return;
    _transmissionType = value;
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

  void setSelectedTenureType(String? value) {
    _tenureType = value;
    notifyListeners();
  }

  // Pet
  void setAge(AgeTimeType? value) {
    if (value == null) return;
    _age = value;
    notifyListeners();
  }

  void setTime(AgeTimeType? value) {
    if (value == null) return;
    _time = value;
    notifyListeners();
  }

  void setAccessCode(String? value) {
    if (value == null) return;
    _accessCode = value;
    // notifyListeners();
  }

  void setPetCategory(PetCategory? category) {
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
//

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
        _sizeColorEntities.indexWhere((SizeColorModel e) => e.value == size);

    if (sizeIndex != -1) {
      final SizeColorModel existingSize = _sizeColorEntities[sizeIndex];

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
          value: size,
          id: size,
          colors: <ColorEntity>[
            ColorEntity(code: color, quantity: quantity),
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
        _sizeColorEntities.indexWhere((SizeColorModel e) => e.value == size);
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
  void clearAllSizeColorCombinations() {
    _sizeColorEntities.clear();
    notifyListeners();
  }

  void setVehicleColor(String value) {
    _selectedVehicleColor = value;
  }

  Future<List<ColorOptionEntity>> colorOptions() async {
    final String jsonString =
        await rootBundle.loadString('assets/jsons/colors.json');
    final Map<String, dynamic> colorsMap = jsonDecode(jsonString);
    final Map<String, dynamic> colors = colorsMap['colors'];
    return colors.entries.map((MapEntry<String, dynamic> entry) {
      return ColorOptionModel.fromJson(entry.value);
    }).toList();
  }

  // Load colors into the provider
  Future<void> fetchColors() async {
    _colors = await colorOptions();
    notifyListeners();
  }

  /// Getter
  ListingType? get listingType => _listingType ?? ListingType.items;
  SubCategoryEntity? get selectedCategory => _selectedCategory;
  bool get isDiscounted => _isDiscounted;
  List<DiscountEntity> get discounts => _discounts;
  List<SizeColorModel> get sizeColorEntities => _sizeColorEntities;
  LocationNameEntity? get selectedLocation => _selectedLocation;

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
  TransmissionType get transmissionType => _transmissionType;
  TextEditingController get engineSize => _engineSize;
  TextEditingController get mileage => _mileage;
  TextEditingController get bodytype => _bodytype;
  TextEditingController get make => _make;
  TextEditingController get model => _model;
  TextEditingController get year => _year;
  TextEditingController get emission => _emission;
  TextEditingController get doors => _doors;
  TextEditingController get seats => _seats;
  TextEditingController get location => _location;

  // Property
  TextEditingController get bedroom => _bedroom;
  TextEditingController get bathroom => _bathroom;
  String? get tenureType => _tenureType;
  String? get selectedPropertySubCategory => _selectedPropertySubCategory;
  String? get selectedPropertyType => _selectedPropertyType;
  bool get garden => _garden;
  bool get parking => _parking;
  bool get animalFriendly => _animalFriendly;
  String? get selectedEnergyRating => _selectedEnergyRating;
  // Pet
  TextEditingController get breed => _breed;
  AgeTimeType? get age => _age;
  PetCategory? get petCategory => _petCategory;
  bool? get healthChecked => _healthChecked;
  bool? get petsCategory => _petsCategory;
  bool? get wormAndFleaTreated => _wormAndFleaTreated;
  bool? get vaccinationUpToDate => _vaccinationUpToDate;
  AgeTimeType? get time => _time;
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

  //
  /// Controller
  ListingType? _listingType;
  SubCategoryEntity? _selectedCategory;
  bool _isDiscounted = false;
  final List<DiscountEntity> _discounts = <DiscountEntity>[
    DiscountEntity(quantity: 2, discount: 0),
    DiscountEntity(quantity: 3, discount: 0),
    DiscountEntity(quantity: 5, discount: 0),
  ];
  // Selected Category
  // Size and Color
  final List<SizeColorModel> _sizeColorEntities = <SizeColorModel>[];
  //
  ConditionType _condition = ConditionType.newC;
  bool _acceptOffer = true;
  PrivacyType _privacy = PrivacyType.public;
  DeliveryType _deliveryType = DeliveryType.paid;
  // Cloth and Foot
  String _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;
  List<ColorOptionEntity> _colors = <ColorOptionEntity>[];

  // Vehicle
  TransmissionType _transmissionType = TransmissionType.auto;
  final TextEditingController _engineSize = TextEditingController();
  final TextEditingController _mileage = TextEditingController();
  final TextEditingController _make = TextEditingController(
    text: kDebugMode ? 'WolksVegan' : '',
  );
  final TextEditingController _model = TextEditingController(
    text: kDebugMode ? 'Gauche' : '',
  );
  final TextEditingController _bodytype = TextEditingController(
    text: kDebugMode ? 'EV' : '',
  );
  final TextEditingController _year = TextEditingController(
    text: kDebugMode ? '2005' : '',
  );
  final TextEditingController _emission = TextEditingController(
    text: kDebugMode ? 'Toyota' : '',
  );
  final TextEditingController _doors = TextEditingController(
    text: kDebugMode ? '5' : '',
  );
  final TextEditingController _seats = TextEditingController(
    text: kDebugMode ? '4' : '',
  );
  final TextEditingController _location = TextEditingController();
  String? _selectedVehicleColor;
  // Property
  final TextEditingController _bedroom = TextEditingController();
  final TextEditingController _bathroom = TextEditingController();
  String? _tenureType;
  final String _selectedPropertySubCategory = ListingType.property.cids.first;
  String? _selectedEnergyRating;
  String? _selectedPropertyType;

  bool _garden = true;
  bool _parking = true;
  bool _animalFriendly = true;
  // Pet
  final TextEditingController _breed = TextEditingController();
  PetCategory? _petCategory;
  bool? _healthChecked;
  bool? _petsCategory;
  bool? _wormAndFleaTreated;
  bool? _vaccinationUpToDate;
  AgeTimeType? _age;
  AgeTimeType? _time;
  bool _isLoading = false;
  //
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  final TextEditingController _title = TextEditingController(
    text: kDebugMode ? 'Test Title' : '',
  );
  final TextEditingController _description = TextEditingController(
    text: kDebugMode ? 'Test Description' : '',
  );
  final TextEditingController _price = TextEditingController(
    text: kDebugMode ? '100' : '',
  );
  final TextEditingController _brand = TextEditingController(
    text: kDebugMode ? 'Cobra' : '',
  );
  final TextEditingController _quantity = TextEditingController(text: '1');
  final TextEditingController _minimumOffer = TextEditingController(
    text: kDebugMode ? '50' : '',
  );
  final TextEditingController _localDeliveryFee = TextEditingController(
    text: kDebugMode ? '10' : '',
  );
  final TextEditingController _internationalDeliveryFee = TextEditingController(
    text: kDebugMode ? '10' : '',
  );

  String _accessCode = '';

  // Form State
  final GlobalKey<FormState> _itemKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _clothesAndFootKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _vehicleKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _foodAndDrinkKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _propertyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _petKey = GlobalKey<FormState>();
}
