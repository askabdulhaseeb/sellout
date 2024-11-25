import '../../../../../core/usecase/usecase.dart';
import '../entity/business_entity.dart';
import '../repository/business_repository.dart';

class GetBusinessByIdUsecase implements UseCase<BusinessEntity?, String> {
  const GetBusinessByIdUsecase(this.repository);
  final BusinessRepository repository;

  @override
  Future<DataState<BusinessEntity?>> call(String params) async {
    return await repository.getBusiness(params);
  }
}
