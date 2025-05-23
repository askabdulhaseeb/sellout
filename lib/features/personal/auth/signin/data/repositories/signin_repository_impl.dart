import '../../domain/params/login_params.dart';
import '../../domain/repositories/signin_repository.dart';
import '../../domain/params/two_factor_params.dart';
import '../sources/signin_remote_source.dart';

class SigninRepositoryImpl implements SigninRepository {
  const SigninRepositoryImpl(this.remoteSource);
  final SigninRemoteSource remoteSource;

  @override
  Future<DataState<bool>> signin(LoginParams params) async {
    try {
      final DataState<bool> result = await remoteSource.signin(params);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Signin Error: $e'));
    }
  }

  @override
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params) async {
    try {
      final DataState<bool> result =
          await remoteSource.verifyTwoFactorAuth(params);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Two Factor Error: $e'));
    }
  }

  @override
  Future<DataState<bool>> resendTwoFactorCode(TwoFactorParams params) async {
    try {
      final DataState<bool> result =
          await remoteSource.resendTwoFactorCode(params);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Two Factor code Error: $e'));
    }
  }
}
