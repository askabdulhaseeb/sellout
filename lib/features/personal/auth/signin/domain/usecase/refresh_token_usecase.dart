import '../../../../../../core/usecase/usecase.dart';
import '../params/refresh_token_params.dart';
import '../repositories/signin_repository.dart';

class RefreshTokenUsecase implements UseCase<String, RefreshTokenParams> {
  const RefreshTokenUsecase(this.repository);

  final SigninRepository repository;

  @override
  Future<DataState<String>> call(RefreshTokenParams params) async {
    return repository.refreshToken(params);
  }
}
