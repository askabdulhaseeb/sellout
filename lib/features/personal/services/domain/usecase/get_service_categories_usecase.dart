import '../../../../../core/usecase/usecase.dart';
import '../entity/service_category_entity.dart';
import '../repositories/personal_services_repository.dart';

class GetServiceCategoriesUsecase
    implements UseCase<List<ServiceCategoryEntity>, Null> {
  const GetServiceCategoriesUsecase(this.repository);
  final PersonalServicesRepository repository;

  @override
  Future<DataState<List<ServiceCategoryEntity>>> call(Null) async {
    return await repository.serviceCategories();
  }
}
