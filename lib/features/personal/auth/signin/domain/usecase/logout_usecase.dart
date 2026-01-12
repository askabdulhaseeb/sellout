import '../../../../../../core/usecase/usecase.dart';
import '../repositories/signin_repository.dart';

class LogoutUsecase implements UseCase<bool, void> {
  const LogoutUsecase(this.repository);
  final SigninRepository repository;

  @override
  Future<DataState<bool>> call(void params) async {
    return await repository.logout();
  }
}
