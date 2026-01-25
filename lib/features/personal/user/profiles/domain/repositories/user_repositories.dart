import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../views/params/add_remove_supporter_params.dart';
import '../../views/params/update_user_params.dart';
import '../entities/user_entity.dart';
import '../../views/params/block_user_params.dart';

abstract interface class UserProfileRepository {
  Future<DataState<UserEntity?>> byUID(String uid);
  Future<DataState<List<PostEntity>>> getPostByUser(String? uid);
  Future<DataState<List<VisitingEntity>>> iMvisiter();

  Future<DataState<List<VisitingEntity>>> iMhost();

  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
    PickedAttachment photo,
  );
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo);
  Future<DataState<String>> addRemoveSupporters(
    AddRemoveSupporterParams params,
  );
  Future<DataState<bool?>> deleteUser(String value);
  Future<DataState<bool?>> blockUser(BlockUserParams params);
}
