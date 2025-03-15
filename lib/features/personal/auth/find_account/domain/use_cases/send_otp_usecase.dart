import '../../../../../../core/usecase/usecase.dart';
import '../repository/find_account_repository.dart';

class SendEmailForOtpUsecase implements UseCase<String, String> {
  const SendEmailForOtpUsecase(this.repository);
  final FindAccountRepository repository;

  @override
  Future<DataState<String>> call(String email) async {
    return await repository.sendEmailForOtp(email);
  }
}
