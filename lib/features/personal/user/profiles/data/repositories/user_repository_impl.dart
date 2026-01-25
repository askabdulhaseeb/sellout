import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repositories.dart';
import '../../views/params/add_remove_supporter_params.dart';
import '../../views/params/update_user_params.dart';
import '../sources/remote/my_visting_remote.dart';
import '../../../../order/data/source/remote/order_by_user_remote.dart';
import '../sources/remote/post_by_user_remote.dart';
import '../sources/remote/user_profile_remote_source.dart';
<<<<<<< HEAD
import '../../views/params/block_user_params.dart';
=======
>>>>>>> e947def20999a92448313553bb695b63691bc934

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(
    this.userProfileRemoteSource,
    this.postByUserRemote,
    this.myVisitingRemote,
    this.orderByUserRemote,
  );
  final UserProfileRemoteSource userProfileRemoteSource;
  final PostByUserRemote postByUserRemote;
  final MyVisitingRemote myVisitingRemote;
  final OrderByUserRemote orderByUserRemote;

  @override
  Future<DataState<UserEntity?>> byUID(String uid) async {
    return await userProfileRemoteSource.byUID(uid);
  }

  @override
  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await postByUserRemote.getPostByUser(uid);
  }

  @override
  Future<DataState<List<VisitingEntity>>> iMvisiter() async {
    return await myVisitingRemote.iMvisiter();
  }

  @override
  Future<DataState<List<VisitingEntity>>> iMhost() async {
    return await myVisitingRemote.iMhost();
  }

  @override
  Future<DataState<List<AttachmentEntity>>> updateProfilePicture(
<<<<<<< HEAD
    PickedAttachment photo,
  ) async {
=======
      PickedAttachment photo) async {
>>>>>>> e947def20999a92448313553bb695b63691bc934
    return await userProfileRemoteSource.updateProfilePicture(photo);
  }

  @override
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo) async {
    return await userProfileRemoteSource.updatePRofileDetail(photo);
  }

  @override
  Future<DataState<String>> addRemoveSupporters(
<<<<<<< HEAD
    AddRemoveSupporterParams params,
  ) async {
=======
      AddRemoveSupporterParams params) async {
>>>>>>> e947def20999a92448313553bb695b63691bc934
    return await userProfileRemoteSource.addRemoveSupporters(params);
  }

  @override
  Future<DataState<bool?>> deleteUser(String value) async {
    return await userProfileRemoteSource.deleteUser(value);
  }

<<<<<<< HEAD
  @override
  Future<DataState<bool?>> blockUser(BlockUserParams params) async {
    return await userProfileRemoteSource.blockUser(params);
  }
=======
>>>>>>> e947def20999a92448313553bb695b63691bc934
}
