import '../../../../../../core/usecase/usecase.dart';
import '../../../data/models/cart/postage_Detail_response_model.dart';
import '../../entities/cart/postage_detail_response_entity.dart';
import '../../param/get_postage_detail_params.dart';
import '../../repositories/cart_repository.dart';

class GetPostageDetailUsecase
    implements UseCase<PostageDetailResponseEntity, GetPostageDetailParam> {
  const GetPostageDetailUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<PostageDetailResponseModel>> call(
      GetPostageDetailParam param) async {
    return await _repository.getPostageDetails(param);
  }
}
