import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/signup_is_valid_params.dart';
import '../repositories/signup_repository.dart';

class IsValidUsecase implements UseCase<bool, SignupIsValidParams> {
  const IsValidUsecase(this.repository);
  final SignupRepository repository;

  @override
  Future<DataState<bool>> call(SignupIsValidParams params) async {
    return await repository.isValid(params);
  }
}
