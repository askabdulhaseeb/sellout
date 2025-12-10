import '../../../../../../core/usecase/usecase.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/domain/param/submit_shipping_param.dart';
import '../repository/postage_repository.dart';

class AddShippingUsecase
    implements UseCase<AddShippingResponseModel, SubmitShippingParam> {
  const AddShippingUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<AddShippingResponseModel>> call(
      SubmitShippingParam param) async {
    return await _repository.addShipping(param);
  }
}
