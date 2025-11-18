import '../../../../../../core/usecase/usecase.dart';
import '../../../data/models/cart/add_shipping_response_model.dart';
import '../../param/submit_shipping_param.dart';
import '../../repositories/cart_repository.dart';

class AddShippingUsecase
    implements UseCase<AddShippingResponseModel, SubmitShippingParam> {
  const AddShippingUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<AddShippingResponseModel>> call(
      SubmitShippingParam param) async {
    return await _repository.addShipping(param);
  }
}
