import '../../../../../../core/usecase/usecase.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../repositories/user_repositories.dart';

class UpdateProfilePictureUsecase implements UseCase<bool, PickedAttachment> {
  const UpdateProfilePictureUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;

  @override
  Future<DataState<bool>> call(PickedAttachment params) async {
    return await userProfileRepository.updateProfilePicture(params);
  }
}
