import '../../../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repositories.dart';

class GetBlockedUsersUsecase implements UseCase<List<UserEntity>, void> {
  const GetBlockedUsersUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;

  @override
  Future<DataState<List<UserEntity>>> call(_) async {
    try {
      return await userProfileRepository.getBlockedUsers();
    } catch (e) {
      return DataFailer<List<UserEntity>>(CustomException('Error: $e'));
    }
  }
}
