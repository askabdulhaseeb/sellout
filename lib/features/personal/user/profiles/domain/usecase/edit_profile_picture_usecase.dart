import '../../../../../../core/usecase/usecase.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../repositories/user_repositories.dart';

class UpdateProfilePictureUsecase implements UseCase<List<AttachmentEntity>, PickedAttachment> {
  const UpdateProfilePictureUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;

  @override
  Future<DataState<List<AttachmentEntity>>> call(PickedAttachment params) async {
    return await userProfileRepository.updateProfilePicture(params);
  }
}
