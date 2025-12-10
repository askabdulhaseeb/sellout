import '../../../../../../core/usecase/usecase.dart';
import '../../../personal/basket/domain/param/get_postage_detail_params.dart';
import '../../data/models/postage_detail_repsonse_model.dart';
import '../entities/postage_detail_response_entity.dart';
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
