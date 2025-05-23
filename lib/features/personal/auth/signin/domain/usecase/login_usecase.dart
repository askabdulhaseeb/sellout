import '../../../../../../core/usecase/usecase.dart';
import '../params/login_params.dart';
import '../repositories/signin_repository.dart';

class LoginUsecase implements UseCase<bool, LoginParams> {
  const LoginUsecase(this.repository);
  final SigninRepository repository;

  @override
  Future<DataState<bool>> call(LoginParams params) async {
    try {
      return await repository.signin(params);
    } catch (e) {
      print(e);
    }
    return DataFailer<bool>(CustomException('Error'));
  }
}
