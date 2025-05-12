import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/usecase/add_address_usecase.dart';
import '../../domain/usecase/update_address_usecase.dart';
import '../params/add_address_param.dart';

class AddAddressProvider extends ChangeNotifier {
  AddAddressProvider(this._addAddressUsecase, this._updateAddressUsecase);
  final AddAddressUsecase _addAddressUsecase;
  final UpdateAddressUsecase _updateAddressUsecase;

  // ===========================
  // Variables
  // ===========================

  PhoneNumberEntity? _phoneNumber;
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _townCityController = TextEditingController();
  String _selectedCountry = '';
  bool _isDefault = false;
  String _addressId = '';
  String _action = '';
  String? _addressCategory;
  // ===========================
  // Getters
  // ===========================

  PhoneNumberEntity? get phoneNumber => _phoneNumber;
  TextEditingController get postalCodeController => _postalCodeController;
  TextEditingController get address1Controller => _address1Controller;
  TextEditingController get townCityController => _townCityController;
  String get selectedCountry => _selectedCountry;
  String get addressId => _addressId;
  bool get isDefault => _isDefault;
  String get action => _action;
  String? get addressCategory => _addressCategory;

  AddressParams get addressParams => AddressParams(
        addressId: addressId,
        recipientName: LocalAuth.currentUser?.displayName ?? '',
        address1: _address1Controller.text,
        townCity: _townCityController.text,
        phoneNumber: LocalAuth.currentUser?.phoneNumber ?? '',
        postalCode: _postalCodeController.text,
        addressCategory: _addressCategory ?? '',
        country: _selectedCountry,
        isDefault: _isDefault,
        action: _action,
      );

  // ===========================
  // Setters
  // ===========================

  set phoneNumber(PhoneNumberEntity? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  set action(String value) {
    _action = value;
    notifyListeners();
  }

  void setaddressCategory(String? value) {
    _addressCategory = value;
    notifyListeners();
  }

  void updateVariable(AddressEntity address) async {
    // phoneNumber =   await PhoneNumberEntity.fromJson(address.phoneNumber, address.country);
    _postalCodeController.text = address.postalCode;
    _address1Controller.text = address.address;
    _townCityController.text = address.townCity;
    _selectedCountry = address.country;
    _isDefault = address.isDefault;
    _addressId = address.addressID;
  }

  set selectedCountry(String value) {
    _selectedCountry = value;
    notifyListeners(); // Make sure to notify listeners to update the UI
  }

  // ===========================
  // View Functions
  // ===========================
  void toggleDefault() {
    _isDefault = !_isDefault;
    notifyListeners();
  }

  // ===========================
  // API Functions
  // ===========================

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
        _showErrorSnackbar(context, error);
        return DataFailer<bool>(CustomException(error));
      } else {
        const String error = 'Unexpected error';
        _showErrorSnackbar(context, error);
        return DataFailer<bool>(CustomException(error));
      }
    } catch (e, stc) {
      final String error = 'Exception: $stc';
      _showErrorSnackbar(context, error);
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
        _showErrorSnackbar(context, error);
        return DataFailer<bool>(CustomException(error));
      } else {
        const String error = 'Unexpected error';
        _showErrorSnackbar(context, error);
        return DataFailer<bool>(CustomException(error));
      }
    } catch (e, stc) {
      final String error = 'Exception: $stc';
      _showErrorSnackbar(context, error);
      return DataFailer<bool>(CustomException(error));
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    // Show snackbar with error message
    AppSnackBar.showSnackBar(context, message);
  }

  // ===========================
  // Cleanup
  // ===========================
  void disposeControllers() {
    phoneNumber = null;
    _action = '';
    _addressId = '';
    _postalCodeController.clear();
    _address1Controller.clear();
    _townCityController.clear();
    _selectedCountry = '';
    _addressCategory = null;
    _isDefault = false;
  }
}
