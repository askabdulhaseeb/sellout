import '../../../../../core/sources/data_state.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../domain/repositories/personal_services_repository.dart';
import '../sources/services_explore_api.dart';

class PersonalServicesRepositoryImpl implements PersonalServicesRepository {
  const PersonalServicesRepositoryImpl(this.servicesApi);
  final ServicesExploreApi servicesApi;

  @override
  Future<DataState<List<ServiceEntity>>> specialOffers() async {
    return await servicesApi.specialOffers();
  }
}
