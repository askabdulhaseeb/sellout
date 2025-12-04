import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../user/profiles/views/params/update_user_params.dart';
import '../params/add_address_param.dart';

class AddSellingAddressProvider extends ChangeNotifier {
  AddSellingAddressProvider(this._updateSellingAddressUsecase);

  // MARK: Address

  AddressEntity? _selectedAddress;
  AddressEntity? get selectedAddress => _selectedAddress;
  set selectedAddress(AddressEntity? value) {
    _selectedAddress = value;
    notifyListeners();
  }

  // MARK: Dependencies
  final UpdateProfileDetailUsecase _updateSellingAddressUsecase;

  // MARK: Internal state / variables

  PhoneNumberEntity? _phoneNumber;
  bool _isLoading = false;

  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();

  String? _city;
  StateEntity? _state;
  CountryEntity? _selectedCountryEntity;

  bool? _isDefault;
  String _addressId = '';
  String _action = '';
  String? _addressCategory;

  // MARK: Public getters

  PhoneNumberEntity? get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  TextEditingController get recipientNameController => _recipientNameController;
  TextEditingController get postalCodeController => _postalCodeController;
  TextEditingController get address1Controller => _address1Controller;
  TextEditingController get address2Controller => _address2Controller;
  String? get city => _city;
  StateEntity? get state => _state;
  CountryEntity? get selectedCountryEntity => _selectedCountryEntity;
  String get addressId => _addressId;
  bool? get isDefault => _isDefault;
  String get action => _action;
  String? get addressCategory => _addressCategory;

  AddressParams get addressParams => AddressParams(
    addressId: addressId,
    recipientName: _recipientNameController.text,
    address1: _address1Controller.text,
    address2: _address2Controller.text,
    city: _city ?? '',
    state: _state?.stateName ?? '',
    phoneNumber: _phoneNumber?.fullNumber ?? '',
    postalCode: _postalCodeController.text,
    addressCategory: _addressCategory ?? '',
    country: _selectedCountryEntity?.countryName ?? '',
    isDefault: null,
    action: _action,
  );

  // MARK: Setters/set functions
  void setloading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPhoneNumber(PhoneNumberEntity? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setStateEntity(StateEntity value) {
    _state = value;
    _city = null;
    notifyListeners();
  }

  void setaddressCategory(String? value) {
    _addressCategory = value;
    notifyListeners();
  }

  set action(String value) {
    _action = value;
    notifyListeners();
  }

  Future<void> updateVariable(AddressEntity address) async {
    _phoneNumber = await PhoneNumberEntity.fromJson(address.phoneNumber);
    // Set country
    _selectedCountryEntity = address.country;
    // Set state and city
    _state = address.state;
    _city = address.city;
    // Set other fields
    _postalCodeController.text = address.postalCode;
    _address1Controller.text = address.address1;
    _address2Controller.text = address.address2;
    _recipientNameController.text = address.recipientName;
    _isDefault = address.isDefault;
    _addressId = address.addressID;
    _addressCategory = address.category;
    _selectedAddress = address;
    notifyListeners();
  }

  void setCountryEntity(CountryEntity? value) {
    _selectedCountryEntity = value;
    debugPrint(_selectedCountryEntity?.states.first.stateName);
    // Reset dependent fields when country changes
    _state = null;
    _city = null;
    notifyListeners();
  }

  // MARK: API Functions
  Future<DataState<String>> saveSellingAddress(BuildContext context) async {
    setloading(true);
    try {
      final DataState<String> result = await _updateSellingAddressUsecase.call(
        UpdateUserParams(sellingAddress: addressParams),
      );
      if (!context.mounted) {
        setloading(false);
        return DataFailer<String>(CustomException('Context not mounted'));
      }
      if (result is DataSuccess) {
        LocalAuth.notifySellingAddressChanged();
        setloading(false);
        Navigator.pop(context);
        return result;
      } else {
        final String error = result.exception?.reason ?? 'Unknown error';
        AppSnackBar.showSnackBar(context, error);
        setloading(false);
        return DataFailer<String>(CustomException(error));
      }
    } catch (e, stc) {
      final String error = 'Exception: $stc';
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, error);
      }
      setloading(false);
      return DataFailer<String>(CustomException(error));
    }
  }

  // MARK: Cleanup
  void disposeControllers() {
    _phoneNumber = null;
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
