import '../../domain/repositories/signin_repository.dart';
import '../sources/signin_remote_source.dart';

class SigninRepositoryImpl implements SigninRepository {
  const SigninRepositoryImpl(this.remoteSource);
  final SigninRemoteSource remoteSource;

  @override
  Future<DataState<bool>> signin(String email, String password) async {
    try {
      final bool result = await remoteSource.signin(email, password);
      return DataSuccess<bool>('', result);
    } catch (e) {
      print(e);
    }
    return DataFailer<bool>(CustomException('Error'));
  }

  @override
  Future<DataState<bool>> forgotPassword(String email) async {
    try {
      final bool result = await remoteSource.forgotPassword(email);
      return DataSuccess<bool>('', result);
    } catch (e) {
      print(e);
    }
    return DataFailer<bool>(CustomException('Error'));
  }
}
