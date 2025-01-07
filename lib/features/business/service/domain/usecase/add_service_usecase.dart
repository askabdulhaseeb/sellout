import '../../../../../core/usecase/usecase.dart';
import '../params/add_service_param.dart';
import '../repositories/add_service_repository.dart';

class AddServiceUsecase implements UseCase<bool, AddServiceParam> {
  const AddServiceUsecase(this.repository);
  final AddServiceRepository repository;

  @override
  Future<DataState<bool>> call(AddServiceParam params) async =>
      await repository.addService(params);
}
