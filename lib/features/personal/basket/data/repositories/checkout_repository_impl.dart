import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/checkout/payment_intent_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../sources/remote/checkout_remote_api.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._remote);
  final CheckoutRemoteAPI _remote;

  @override
  Future<DataState<PaymentIntentEntity>> cartPayIntent() async {
    return await _remote.cartPayIntent();
  }
}
