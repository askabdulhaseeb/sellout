import '../../../../../core/sources/data_state.dart';
import '../../../../business/business_page/domain/entities/services_list_responce_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../params/get_categorized_services_params.dart';

abstract interface class PersonalServicesRepository {
  Future<DataState<List<ServiceEntity>>> specialOffers();
  Future<DataState<ServicesListResponceEntity>> getServicesByCategory(
      GetServiceCategoryParams type);
}
