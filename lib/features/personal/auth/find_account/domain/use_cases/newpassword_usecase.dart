import '../../../../../../core/usecase/usecase.dart';
import '../../view/params/new_password_params.dart';
import '../repository/find_account_repository.dart';

class NewPasswordUsecase implements UseCase<String, NewPasswordParams> {
  const NewPasswordUsecase(this.repository);
  final FindAccountRepository repository;

  @override
  Future<DataState<String>> call(NewPasswordParams params) async {
    return await repository.newPassword(params);
  }
}
