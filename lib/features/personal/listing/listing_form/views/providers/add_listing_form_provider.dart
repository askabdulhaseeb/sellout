import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/listing/pet/age_time_type.dart';
import '../../../../../../core/enums/listing/vehicle/transmission_type.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../domain/entities/sub_category_entity.dart';

class AddListingFormProvider extends ChangeNotifier {
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
    await Future<void>.delayed(const Duration(seconds: 2));
    setLoading(false);
  }

  Future<void> _onVehicleSubmit() async {
    if (!(_vehicleKey.currentState?.validate() ?? false)) return;
    setLoading(true);
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

  //
  /// Getter
  ListingType? get listingType => _listingType ?? ListingType.items;
  SubCategoryEntity? get selectedCategory => _selectedCategory;
  //
  List<PickedAttachment> get attachments => _attachments;
  ConditionType get condition => _condition;
  bool get acceptOffer => _acceptOffer;
  PrivacyType get privacy => _privacy;
  DeliveryType get deliveryType => _deliveryType;
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
  // Selected Category
  // Size and Color
  ConditionType _condition = ConditionType.newC;
  bool _acceptOffer = true;
  PrivacyType _privacy = PrivacyType.public;
  DeliveryType _deliveryType = DeliveryType.paid;
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
