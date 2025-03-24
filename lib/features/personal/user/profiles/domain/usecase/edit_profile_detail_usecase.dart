import '../../../../../../core/usecase/usecase.dart';
import '../../views/params/update_user_params.dart';
import '../repositories/user_repositories.dart';

class UpdateProfileDetailUsecase implements UseCase<String,UpdateUserParams> {
  const UpdateProfileDetailUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<String>> call(UpdateUserParams params) async {
    return await userProfileRepository.updatePRofileDetail(params);
  }
}