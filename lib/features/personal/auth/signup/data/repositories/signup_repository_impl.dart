import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../domain/repositories/signup_repository.dart';
import '../../views/params/signup_basic_info_params.dart';
import '../../views/params/signup_is_valid_params.dart';
import '../../views/params/signup_send_opt_params.dart';
import '../sources/signup_api.dart';

class SignupRepositoryImpl implements SignupRepository {
  const SignupRepositoryImpl(this.api);
  final SignupApi api;

  @override
  Future<DataState<String>> signupBasicInfo(
    SignupBasicInfoParams params,
  ) async {
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

  @override
  Future<DataState<bool>> verifyImage(PickedAttachment attachment) async {
    return await api.verifyImage(attachment);
  }

  @override
  Future<DataState<bool>> isValid(SignupIsValidParams params) async {
    return await api.isValid(params);
  }
}
