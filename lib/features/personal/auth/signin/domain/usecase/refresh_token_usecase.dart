import '../../../../../../core/usecase/usecase.dart';
import '../../data/sources/local/local_auth.dart';
import '../params/refresh_token_params.dart';
import '../repositories/signin_repository.dart';
import '../../../../../../core/functions/app_log.dart';

class RefreshTokenUsecase implements UseCase<String, RefreshTokenParams> {
  const RefreshTokenUsecase(this.repository);

  final SigninRepository repository;

  @override
  Future<DataState<String>> call(RefreshTokenParams params) async {
    return repository.refreshToken(params);
  }

  Future<DataState<String>> refreshIfNeeded() async {
          final String? uid = LocalAuth.uid;

    try { 
      final String refreshToken = LocalAuth.currentUser?.refreshToken ?? '';
      if (uid == null || refreshToken.isEmpty) {
        AppLog.error('No user or refresh token available for refresh',
            name: 'RefreshTokenUsecase.refreshIfNeeded');
        return DataFailer<String>(CustomException('No user or refresh token'));
      }
      final DataState<String> result = await repository
          .refreshToken(RefreshTokenParams(refreshToken: refreshToken));
      if (result is DataSuccess) {
        AppLog.info('Token refreshed');
      } else if (result is DataFailer) {
        AppLog.error('Failed refreshing token',
            error: result.exception,
            name: 'RefreshTokenUsecase.refreshIfNeeded');
      }
      return result;
    } catch (e, s) {
      AppLog.error('Exception refreshing token',
          error: e, stackTrace: s, name: 'RefreshTokenUsecase.refreshIfNeeded');
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
