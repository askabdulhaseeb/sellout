import '../../../../../../core/usecase/usecase.dart';
import '../../entities/checkout/payment_intent_entity.dart';
import '../../repositories/checkout_repository.dart';

class PayIntentUsecase implements UseCase<PaymentIntentEntity, String> {
  PayIntentUsecase(this._repository);
  final CheckoutRepository _repository;

  @override
  Future<DataState<PaymentIntentEntity>> call(String param) async {
    return await _repository.cartPayIntent();
  }
}
