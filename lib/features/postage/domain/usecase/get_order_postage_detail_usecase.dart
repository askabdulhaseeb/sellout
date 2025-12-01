import '../../../../../../core/usecase/usecase.dart';
import '../params/get_order_postage_detail_params.dart';
import '../repository/postage_repository.dart';

class GetOrderPostageDetailUsecase
    implements UseCase<bool, GetOrderPostageDetailParam> {
  const GetOrderPostageDetailUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<bool>> call(GetOrderPostageDetailParam param) async {
    return await _repository.getOrderPostageDetail(param);
  }
}
