import '../../../../../../core/usecase/usecase.dart';
import '../../param/submit_shipping_param.dart';
import '../../repositories/cart_repository.dart';

class AddShippingUsecase implements UseCase<bool, SubmitShippingParam> {
  const AddShippingUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<bool>> call(SubmitShippingParam param) async {
    return await _repository.addShipping(param);
  }
}
