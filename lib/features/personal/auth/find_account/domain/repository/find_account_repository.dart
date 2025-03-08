import '../../../../../../core/sources/api_call.dart';
import '../../view/params/forgot_params.dart';
import '../../view/params/new_password_params.dart';

abstract class FindAccountRepository {
  Future<DataState<Map<String, dynamic>>> findAccount(String phoneOrEmail);
  Future<DataState<String>> sendEmailForOtp(OtpResponseParams params);
    Future<DataState<String>> newPassword(NewPasswordParams params);

}
