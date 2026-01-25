import '../../../../../core/usecase/usecase.dart';
import '../entities/service_point_entity.dart';
import '../params/get_service_points_param.dart';
import '../repository/postage_repository.dart';

/// Usecase for fetching service points (pickup locations) from the API
class GetServicePointsUsecase
    implements UseCase<ServicePointsResponseEntity, GetServicePointsParam> {
  const GetServicePointsUsecase(this._repository);

  final PostageRepository _repository;

  @override
  Future<DataState<ServicePointsResponseEntity>> call(
    GetServicePointsParam param,
  ) async {
    return await _repository.getServicePoints(param);
  }
}
