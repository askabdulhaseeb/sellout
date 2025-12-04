import '../../../../../../core/sources/data_state.dart';
import '../../domain/repo_impl/add_address_repo.dart';
import '../../views/params/add_address_param.dart';
import '../source/add_address_remote_source.dart';

class AddAddressRepositoryImpl extends AddAddressRepository {
  AddAddressRepositoryImpl(this.remoteSource);
  final AddAddressRemoteSource remoteSource;

  @override
  Future<DataState<bool>> addAddress(AddressParams params) {
    return remoteSource.addAddress(params);
  }
  
  @override
  Future<DataState<bool>> addSellingAddress(AddressParams params) {
    return remoteSource.addSellingAddress(params);
  }

  @override
  Future<DataState<bool>> updateAddress(AddressParams params) {
    return remoteSource.updateAddress(params);
  }

}
