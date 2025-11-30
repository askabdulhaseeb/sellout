import '../../../../../../core/usecase/usecase.dart';
import '../../../personal/basket/data/models/cart/postage_Detail_response_model.dart';
import '../../../personal/basket/domain/entities/cart/postage_detail_response_entity.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../repository/postage_repository.dart';


class GetPostageDetailUsecase
    implements UseCase<PostageDetailResponseEntity, GetPostageDetailParam> {
  const GetPostageDetailUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<PostageDetailResponseModel>> call(
      GetPostageDetailParam param) async {
    return await _repository.getPostageDetails(param);
  }
}
