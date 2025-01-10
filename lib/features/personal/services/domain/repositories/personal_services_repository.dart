import '../../../../../core/sources/data_state.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';

abstract interface class PersonalServicesRepository {
  Future<DataState<List<ServiceEntity>>> specialOffers();
}