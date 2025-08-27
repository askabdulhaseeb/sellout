import '../../../../../../core/usecase/usecase.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../repositories/checkout_repository.dart';

class PayIntentUsecase implements UseCase<String, AddressEntity> {
  PayIntentUsecase(this._repository);
  final CheckoutRepository _repository;

  @override
  Future<DataState<String>> call(AddressEntity address) async {
    return await _repository.cartPayIntent(AddressModel.fromEntity(address));
  }
}
