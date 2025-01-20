import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/signup_basic_info_params.dart';
import '../repositories/signup_repository.dart';

class RegisterUserUsecase implements UseCase<String, SignupBasicInfoParams> {
  const RegisterUserUsecase(this.repository);
  final SignupRepository repository;

  @override
  Future<DataState<String>> call(SignupBasicInfoParams params) async {
    return await repository.signupBasicInfo(params);
  }
}
