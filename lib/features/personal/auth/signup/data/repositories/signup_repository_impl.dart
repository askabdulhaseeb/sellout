import '../../../../../../core/sources/data_state.dart';
import '../../domain/repositories/signup_repository.dart';
import '../../views/params/signup_basic_info_params.dart';
import '../../views/params/signup_send_opt_params.dart';
import '../sources/signup_api.dart';

class SignupRepositoryImpl implements SignupRepository {
  const SignupRepositoryImpl(this.api);
  final SignupApi api;

  @override
  Future<DataState<String>> signupBasicInfo(SignupBasicInfoParams params) async {
    return await api.signupBasicInfo(params);
  }

  @override
  Future<DataState<String>> signupSendOTP(SignupOptParams params) async {
    return await api.signupSendOTP(params);
  }

  @override
  Future<DataState<bool>> signupVerifyOTP(SignupOptParams params) async {
    return await api.signupVerifyOTP(params);
  }
}
