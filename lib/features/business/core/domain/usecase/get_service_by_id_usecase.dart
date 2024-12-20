import '../../../../../core/functions/app_log.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entity/service/service_entity.dart';
import '../repository/business_repository.dart';

class GetServiceByIdUsecase implements UseCase<ServiceEntity?, String> {
  const GetServiceByIdUsecase(this.repository);
  final BusinessRepository repository;

  @override
  Future<DataState<ServiceEntity?>> call(String params) async {
    if (params.isEmpty) {
      AppLog.error(
        'params is empty',
        name: 'GetServiceByIdUsecase',
      );
      return DataFailer<ServiceEntity?>(CustomException('na'));
    }
    return await repository.getService(params);
  }
}
