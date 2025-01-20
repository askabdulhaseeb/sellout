import '../../../../../../core/sources/data_state.dart';
import '../../views/params/signup_basic_info_params.dart';
import '../../views/params/signup_send_opt_params.dart';

abstract interface class SignupRepository {
  Future<DataState<String>> signupBasicInfo(SignupBasicInfoParams params);
  Future<DataState<String>> signupSendOTP(SignupOptParams params);
  Future<DataState<bool>> signupVerifyOTP(SignupOptParams params);
}
