import '../../../../../core/usecase/usecase.dart';
import '../entities/services_list_responce_entity.dart';
import '../params/get_business_serives_param.dart';
import '../repositories/business_page_services_repository.dart';

class GetServicesListByBusinessIdUsecase
    implements UseCase<ServicesListResponceEntity, GetBusinessSerivesParam> {
  GetServicesListByBusinessIdUsecase(this._repository);
  final BusinessPageServicesRepository _repository;

  @override
  Future<DataState<ServicesListResponceEntity>> call(
      GetBusinessSerivesParam param) async {
    return await _repository.businessServices(param);
  }
}
