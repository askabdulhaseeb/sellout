import '../../../../../../core/usecase/usecase.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../entities/checkout/check_out_entity.dart';
import '../../repositories/checkout_repository.dart';

class GetCheckoutUsecase implements UseCase<CheckOutEntity, AddressEntity> {
  GetCheckoutUsecase(this._repository);
  final CheckoutRepository _repository;

  @override
  Future<DataState<CheckOutEntity>> call(AddressEntity address) async {
    return await _repository.getCheckout(AddressModel.fromEntity(address));
  }
}
