import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/block_user_params.dart';
import '../repositories/user_repositories.dart';

class BlockUserUsecase implements UseCase<bool?, BlockUserParams> {
  const BlockUserUsecase(this.userProfileRepository);

  final UserProfileRepository userProfileRepository;

  @override
  Future<DataState<bool?>> call(BlockUserParams params) async {
    return await userProfileRepository.blockUser(params);
  }
}
