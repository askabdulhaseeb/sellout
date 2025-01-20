import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/signup_send_opt_params.dart';
import '../repositories/signup_repository.dart';

class SendPhoneOtpUsecase implements UseCase<String, SignupOptParams> {
  const SendPhoneOtpUsecase(this.repository);
  final SignupRepository repository;

  @override
  Future<DataState<String>> call(SignupOptParams params) async {
    return await repository.signupSendOTP(params);
  }
}
