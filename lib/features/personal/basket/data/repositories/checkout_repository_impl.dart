import '../../../../../core/sources/data_state.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/checkout/check_out_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../sources/remote/checkout_remote_api.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._remote);
  final CheckoutRemoteAPI _remote;
  @override
  Future<DataState<CheckOutEntity>> getCheckout(AddressModel address) async {
    return await _remote.getCheckout(address);
  }

  @override
  Future<DataState<String>> cartPayIntent() async {
    return await _remote.cartPayIntent();
  }
}
