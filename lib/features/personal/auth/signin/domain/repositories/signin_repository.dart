import '../../../../../../core/sources/data_state.dart';
import '../../views/params/two_factor_params.dart';
export '../../../../../../core/sources/data_state.dart';

abstract interface class SigninRepository {
  Future<DataState<bool>> signin(String email, String password);
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params);
}
