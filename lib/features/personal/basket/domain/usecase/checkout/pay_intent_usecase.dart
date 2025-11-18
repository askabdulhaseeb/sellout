import '../../../../../../core/usecase/usecase.dart';
import '../../repositories/checkout_repository.dart';

class PayIntentUsecase implements UseCase<String, String> {
  PayIntentUsecase(this._repository);
  final CheckoutRepository _repository;

  @override
  Future<DataState<String>> call(String param) async {
    return await _repository.cartPayIntent();
  }
}
