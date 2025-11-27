import '../../../../../../core/usecase/usecase.dart';
import '../repositories/user_repositories.dart';

class DeleteUserUsecase implements UseCase<bool?, String> {
  const DeleteUserUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<bool?>> call(String params) async {
    return await userProfileRepository.deleteUser(params);
  }
}
