import '../../../../../core/usecase/usecase.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../repositories/personal_services_repository.dart';

class GetSpecialOfferUsecase implements UseCase<List<ServiceEntity>, bool> {
  const GetSpecialOfferUsecase(this.repository);
  final PersonalServicesRepository repository;

  @override
  Future<DataState<List<ServiceEntity>>> call(_) async {
    return await repository.specialOffers();
  }
}
