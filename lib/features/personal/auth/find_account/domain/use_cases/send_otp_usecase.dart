import '../../../../../../core/usecase/usecase.dart';
import '../../view/params/forgot_params.dart';
import '../repository/find_account_repository.dart';


class SendEmailForOtpUsecase implements UseCase<String,OtpResponseParams > {
  const SendEmailForOtpUsecase(this.repository);
  final FindAccountRepository repository;

  @override
  Future<DataState<String>> call(OtpResponseParams params) async {
    return await repository.sendEmailForOtp(params);
  }
}