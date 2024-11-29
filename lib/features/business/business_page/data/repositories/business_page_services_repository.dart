import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/services_list_responce_entity.dart';
import '../../domain/params/get_business_serives_param.dart';
import '../../domain/repositories/business_page_services_repository.dart';
import '../sources/get_service_by_business_id_remote.dart';

class BusinessPageServicesRepositoryImpl
    implements BusinessPageServicesRepository {
  BusinessPageServicesRepositoryImpl(this.remote);
  final GetServiceByBusinessIdRemote remote;

  @override
  Future<DataState<ServicesListResponceEntity>> businessServices(
      GetBusinessSerivesParam param) async {
    return await remote.services(
      param.businessID,
      nextKey: param.nextKey,
      sort: param.sort,
    );
  }
}
