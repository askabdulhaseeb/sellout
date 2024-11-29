import '../../../../../core/sources/data_state.dart';
import '../entities/services_list_responce_entity.dart';
import '../params/get_business_serives_param.dart';

abstract interface class BusinessPageServicesRepository {
  Future<DataState<ServicesListResponceEntity>> businessServices(
      GetBusinessSerivesParam param);
}
