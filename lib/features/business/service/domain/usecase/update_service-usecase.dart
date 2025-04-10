import '../../../../../core/usecase/usecase.dart';
import '../params/add_service_param.dart';
import '../repositories/add_service_repository.dart';

class UpdateServiceUsecase implements UseCase<bool, AddServiceParam> {
  const UpdateServiceUsecase(this.repository);
  final AddServiceRepository repository;

  @override
  Future<DataState<bool>> call(AddServiceParam params) async =>
      await repository.updateService(params);
}
