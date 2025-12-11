import '../../../../../../core/usecase/usecase.dart';
import '../params/add_order_label_params.dart';
import '../repository/postage_repository.dart';

class AddOrderShippingUsecase implements UseCase<bool, AddOrderShippingParams> {
  const AddOrderShippingUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<bool>> call(AddOrderShippingParams param) async {
    return await _repository.addOrderShipping(param);
  }
}
