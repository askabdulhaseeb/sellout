import '../../../../../../core/usecase/usecase.dart';
import '../repositories/user_repositories.dart';

class DeactivateUserUsecase implements UseCase<bool?, String> {
  const DeactivateUserUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;

  @override
  Future<DataState<bool?>> call(String params) async {
    // Always return failure since there is no endpoint
    return DataFailer(
      CustomException('Account deactivation is not supported.'),
    );
  }
}
