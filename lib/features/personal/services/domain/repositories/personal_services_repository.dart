import '../../../../../core/sources/data_state.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../entity/service_category_entity.dart';
import '../params/services_by_filters_params.dart';

abstract interface class PersonalServicesRepository {
  Future<DataState<List<ServiceEntity>>> specialOffers();
  Future<DataState<List<ServiceCategoryENtity>>> serviceCategories();
  Future<DataState<List<ServiceEntity>>> getServicesbyFilters(
      ServiceByFiltersParams params);
}
