import '../../../../../../core/sources/data_state.dart';
import '../params/two_factor_params.dart';
import '../params/login_params.dart';
import '../params/refresh_token_params.dart';
export '../../../../../../core/sources/data_state.dart';

abstract interface class SigninRepository {
  Future<DataState<bool>> signin(LoginParams params);
  Future<DataState<String>> refreshToken(RefreshTokenParams params);
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params);
  Future<DataState<bool>> resendTwoFactorCode(TwoFactorParams params);
  Future<DataState<bool>> logout();
}
