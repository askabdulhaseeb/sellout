import '../../../../../core/usecase/usecase.dart';
import '../../../../business/business_page/domain/entities/services_list_responce_entity.dart';
import '../params/get_categorized_services_params.dart';
import '../repositories/personal_services_repository.dart';

class GetServiceCategoryUsecase
    implements UseCase<ServicesListResponceEntity, GetServiceCategoryParams> {
  const GetServiceCategoryUsecase(this.repository);
  final PersonalServicesRepository repository;

  @override
  Future<DataState<ServicesListResponceEntity>> call(
      GetServiceCategoryParams type) async {
    return await repository.getServicesByCategory(type);
  }
}
