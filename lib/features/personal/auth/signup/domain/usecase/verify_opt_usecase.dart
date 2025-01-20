import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/signup_send_opt_params.dart';
import '../repositories/signup_repository.dart';

class VerifyPhoneOtpUsecase implements UseCase<bool, SignupOptParams> {
  const VerifyPhoneOtpUsecase(this.repository);
  final SignupRepository repository;

  @override
  Future<DataState<bool>> call(SignupOptParams params) async {
    return await repository.signupVerifyOTP(params);
  }
}
