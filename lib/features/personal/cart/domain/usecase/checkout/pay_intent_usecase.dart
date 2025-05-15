import '../../../../../../core/usecase/usecase.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../repositories/checkout_repository.dart';

class PayIntentUsecase implements UseCase<bool, AddressEntity> {
  PayIntentUsecase(this._repository);
  final CheckoutRepository _repository;

  @override
  Future<DataState<bool>> call(AddressEntity address) async {
    return await _repository.cartPayIntent(AddressModel.fromEntity(address));
  }
}
