import '../../../../../../core/sources/data_state.dart';
import '../../views/params/add_address_param.dart';

abstract class AddAddressRepository {
  Future<DataState<bool>> addAddress(AddressParams params);
  Future<DataState<bool>> updateAddress(AddressParams params);
}
