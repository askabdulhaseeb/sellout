import '../../domain/repositories/signin_repository.dart';
import '../sources/signin_remote_source.dart';

class SigninRepositoryImpl implements SigninRepository {
  const SigninRepositoryImpl(this.remoteSource);
  final SigninRemoteSource remoteSource;

  @override
  Future<DataState<bool>> signin(String email, String password) async {
    try {
      final DataState<bool> result = await remoteSource.signin(email, password);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Signin Error: $e'));
    }
  }

  @override
  Future<DataState<bool>> forgotPassword(String email) async {
    try {
      final DataState<bool> result = await remoteSource.forgotPassword(email);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Forget Password Error: $e'));
    }
  }
}
