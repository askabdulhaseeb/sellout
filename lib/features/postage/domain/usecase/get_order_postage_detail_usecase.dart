import '../../../../../../core/usecase/usecase.dart';
import '../../data/models/postage_detail_response_model.dart';
import '../entities/postage_detail_response_entity.dart';
import '../params/get_order_postage_detail_params.dart';
import '../repository/postage_repository.dart';

class GetOrderPostageDetailUsecase
    implements
        UseCase<PostageDetailResponseEntity, GetOrderPostageDetailParam> {
  const GetOrderPostageDetailUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<PostageDetailResponseModel>> call(
    GetOrderPostageDetailParam param,
  ) async {
    return await _repository.getOrderPostageDetail(param);
  }
}
