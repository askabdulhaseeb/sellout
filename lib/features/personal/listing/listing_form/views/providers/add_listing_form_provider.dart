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
import '../../../../../../core/enums/listing/vehicle/transmission_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
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

// AddListingUsecase _addlistingUSecase;
  Future<void> submit(BuildContext context) async {
    if (_attachments.isEmpty) {
      AppSnackBar.showSnackBar(
        context,
        'Please add at least one Photo or Video',
      );
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
    _attachments.clear();
    _title.clear();
    _description.clear();
    _price.clear();
    _quantity.clear();
    _minimumOffer.clear();
    _deliveryFee.clear();
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
    // AddListingParam param = AddListingParam(
    //   title: _title.text,
    //   description: _description.text,
    //   price: _price.text,
    //   quantity: _quantity.text,
    //   discount: true,
    //   disc2Items: '5',
    //   disc3Items: '0',
    //   disc5Items: '0',
    //   itemCondition: _condition.json,
    //   acceptOffers: _acceptOffer,
    //   minOfferAmount: _minimumOffer.text,
    //   privacy: _privacy,
    //   accessCode: _accessCode,
    //   deliveryType: _deliveryType,
    //   localDelivery: _deliveryFee.text,
    //   internationalDelivery: '0',
    //   listId: _listingType?.json ?? '',
    //   address: _selectedCategory?.address ?? 'items',
    //   currentLatitude: '0',
    //   currentLongitude: '0',
    //   attachments: _attachments,
    // );
    // await AddListingApi().addItem(param);
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
          localDeliveryAmount: '500',
          internationalDeliveryAmount: '200',
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
      // Optional: stop loading
      // isLoading = false;
      // notifyListeners();
    }
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
  }

  Future<void> _onVehicleSubmit() async {
    if (!(_vehicleKey.currentState?.validate() ?? false)) return;
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
          localDeliveryAmount: '500',
          internationalDeliveryAmount: '200',
          listingType: ListingType.vehicle,
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
      // Optional: stop loading
      // isLoading = false;
      // notifyListeners();
    }
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
  }

  Future<void> _onFoodAndDrinkSubmit() async {
    if (!(_foodAndDrinkKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
  }

  Future<void> _onPropertySubmit() async {
    if (!(_propertyKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
  }

  Future<void> _onPetSubmit() async {
    if (!(_petKey.currentState?.validate() ?? false)) return;
    setLoading(true);
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
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

  // Cloth and Foot
  void setSelectedClothSubCategory(String value) {
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

  //
  List<PickedAttachment> get attachments => _attachments;
  ConditionType get condition => _condition;
  bool get acceptOffer => _acceptOffer;
  PrivacyType get privacy => _privacy;
  DeliveryType get deliveryType => _deliveryType;
  // Cloth and Foot
  String get selectedClothSubCategory => _selectedClothSubCategory;
  List<ColorOptionEntity> get colors => _colors;

  // Vehicle
  TransmissionType get transmissionType => _transmissionType;
  TextEditingController get engineSize => _engineSize;
  TextEditingController get mileage => _mileage;
  // Property
  TextEditingController get bedroom => _bedroom;
  TextEditingController get bathroom => _bathroom;
  bool get garden => _garden;
  bool get parking => _parking;
  bool get animalFriendly => _animalFriendly;
  // Pet
  AgeTimeType? get age => _age;
  AgeTimeType? get time => _time;

  bool get isLoading => _isLoading;
  //
  TextEditingController get title => _title;
  TextEditingController get description => _description;
  TextEditingController get brand => _brand;
  TextEditingController get price => _price;
  TextEditingController get quantity => _quantity;
  TextEditingController get minimumOffer => _minimumOffer;
  TextEditingController get deliveryFee => _deliveryFee;
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

  // Property
  final TextEditingController _bedroom = TextEditingController();
  final TextEditingController _bathroom = TextEditingController();
  bool _garden = true;
  bool _parking = true;
  bool _animalFriendly = true;
  // Pet
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
  final TextEditingController _deliveryFee = TextEditingController(
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
