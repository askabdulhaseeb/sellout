import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/usecase/add_address_usecase.dart';
import '../../domain/usecase/update_address_usecase.dart';
import '../params/add_address_param.dart';

class AddAddressProvider extends ChangeNotifier {
  AddAddressProvider(this._addAddressUsecase, this._updateAddressUsecase);

  // MARK: Dependencies
  final AddAddressUsecase _addAddressUsecase;
  final UpdateAddressUsecase _updateAddressUsecase;

  // MARK: Internal state / variables
  PhoneNumberEntity? _phoneNumber;

  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();

  String? _city;
  StateEntity? _state;
  CountryEntity? _selectedCountryEntity;

  bool _isDefault = false;
  String _addressId = '';
  String _action = '';
  String? _addressCategory;

  // MARK: Public getters
  PhoneNumberEntity? get phoneNumber => _phoneNumber;
  TextEditingController get recipientNameController => _recipientNameController;
  TextEditingController get postalCodeController => _postalCodeController;
  TextEditingController get address1Controller => _address1Controller;
  TextEditingController get address2Controller => _address2Controller;
  String? get city => _city;
  StateEntity? get state => _state;
  CountryEntity? get selectedCountryEntity => _selectedCountryEntity;
  String get addressId => _addressId;
  bool get isDefault => _isDefault;
  String get action => _action;
  String? get addressCategory => _addressCategory;

  AddressParams get addressParams => AddressParams(
        addressId: addressId,
        recipientName: _recipientNameController.text,
        address1: _address1Controller.text,
        address2: address2Controller.text,
        city: _city ?? '',
        state: _state?.stateName ?? '',
        phoneNumber: LocalAuth.currentUser?.phoneNumber ?? '',
        postalCode: _postalCodeController.text,
        addressCategory: _addressCategory ?? '',
        country: _selectedCountryEntity?.countryName ?? '',
        isDefault: _isDefault,
        action: _action,
      );
  // MARK: Setters/set functions

  set phoneNumber(PhoneNumberEntity? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  set action(String value) {
    _action = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setState(StateEntity value) {
    _state = value;
    notifyListeners();
  }

  void setaddressCategory(String? value) {
    _addressCategory = value;
    notifyListeners();
  }

  Future<void> updateVariable(AddressEntity address) async {
    _selectedCountryEntity = address.country;
    _postalCodeController.text = address.postalCode;
    _address1Controller.text = address.address;
    setState(address.state);
    _city = address.city;
    phoneNumber = await PhoneNumberEntity.fromJson(address.phoneNumber);
    _recipientNameController.text = address.recipientName;
    _isDefault = address.isDefault;
    _addressId = address.addressID;
    _addressCategory = address.category;
    notifyListeners();
  }

  set selectedCountryEntity(CountryEntity? value) {
    _selectedCountryEntity = value;
    _state = null;
    _city = null;
    notifyListeners();
  }

  void toggleDefault() {
    _isDefault = !_isDefault;
    notifyListeners();
  }

  // MARK: API Functions
  Future<DataState<bool>> saveAddress(BuildContext context) async {
    try {
      final DataState<bool> result =
          await _addAddressUsecase.call(addressParams);
      debugPrint('add address data ${addressParams.toMap()}');
      if (result is DataSuccess<bool>) {
        debugPrint(result.data);
        Navigator.pop(context);
        return result;
      } else if (result is DataFailer<bool>) {
        final String error = result.exception?.reason ?? 'Unknown error';
        AppSnackBar.showSnackBar(context, error);
        return DataFailer<bool>(CustomException(error));
      } else {
        const String error = 'Unexpected error';
        AppSnackBar.showSnackBar(context, error);
        return DataFailer<bool>(CustomException(error));
      }
    } catch (e, stc) {
      final String error = 'Exception: $stc';
      AppSnackBar.showSnackBar(context, error);
      return DataFailer<bool>(CustomException(error));
    }
  }

  Future<DataState<bool>> updateAddress(BuildContext context) async {
    try {
      final DataState<bool> result =
          await _updateAddressUsecase.call(addressParams);
      debugPrint('add address data ${addressParams.toMap()}');
      if (result is DataSuccess<bool>) {
        debugPrint(result.data);
        Navigator.pop(context);
        return result;
      } else if (result is DataFailer<bool>) {
        final String error = result.exception?.reason ?? 'Unknown error';
        AppSnackBar.showSnackBar(context, error);
        return DataFailer<bool>(CustomException(error));
      } else {
        const String error = 'Unexpected error';
        AppSnackBar.showSnackBar(context, error);
        return DataFailer<bool>(CustomException(error));
      }
    } catch (e, stc) {
      final String error = 'Exception: $stc';
      AppSnackBar.showSnackBar(context, error);
      return DataFailer<bool>(CustomException(error));
    }
  }

  // MARK: Cleanup
  void disposeControllers() {
    phoneNumber = null;
    _action = '';
    _addressId = '';
    _postalCodeController.clear();
    _address1Controller.clear();
    _address2Controller.clear();
    _selectedCountryEntity = null;
    _recipientNameController.clear();
    _city = null;
    _state = null;
    _addressCategory = null;
    _isDefault = false;
    notifyListeners();
  }
}
