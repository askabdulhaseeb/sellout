import '../../../../../core/usecase/usecase.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../params/services_by_filters_params.dart';
import '../repositories/personal_services_repository.dart';

class GetServiceCategoryUsecase
    implements UseCase<List<ServiceEntity>, ServiceByFiltersParams> {
  const GetServiceCategoryUsecase(this.repository);
  final PersonalServicesRepository repository;

  @override
  Future<DataState<List<ServiceEntity>>> call(
      ServiceByFiltersParams params) async {
    return await repository.getServicesbyFilters(params);
  }
}
