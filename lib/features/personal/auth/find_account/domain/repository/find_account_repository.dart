import '../../../../../../core/sources/api_call.dart';
import '../../view/params/new_password_params.dart';
import '../../view/params/verify_pin_params.dart';

abstract class FindAccountRepository {
  Future<DataState<Map<String, dynamic>>> findAccount(String phoneOrEmail);
  Future<DataState<String>> sendEmailForOtp(String email);
    Future<DataState<String>> newPassword(NewPasswordParams params);
 Future<DataState<bool>> verifyOtp(VerifyPinParams params);
}
