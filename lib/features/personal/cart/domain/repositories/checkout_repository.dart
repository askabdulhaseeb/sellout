import '../../../../../core/sources/data_state.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../entities/checkout/check_out_entity.dart';

abstract interface class CheckoutRepository {
  Future<DataState<CheckOutEntity>> getCheckout(AddressModel address);
  Future<DataState<bool>> cartPayIntent(AddressModel params);
}
