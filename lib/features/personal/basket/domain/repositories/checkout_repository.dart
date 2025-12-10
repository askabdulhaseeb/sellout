import '../../../../../core/sources/data_state.dart';
import '../entities/checkout/payment_intent_entity.dart';

abstract interface class CheckoutRepository {
  Future<DataState<PaymentIntentEntity>> cartPayIntent();
}
