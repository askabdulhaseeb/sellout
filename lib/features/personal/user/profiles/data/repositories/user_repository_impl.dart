import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repositories.dart';
import '../../views/params/add_remove_supporter_params.dart';
import '../../views/params/update_user_params.dart';
import '../sources/local/local_blocked_users.dart';
import '../sources/remote/my_visting_remote.dart';
import '../../../../order/data/source/remote/order_by_user_remote.dart';
import '../sources/remote/post_by_user_remote.dart';
import '../sources/remote/user_profile_remote_source.dart';
import '../../views/params/block_user_params.dart';

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
    PickedAttachment photo,
  ) async {
    return await userProfileRemoteSource.updateProfilePicture(photo);
  }

  @override
  Future<DataState<String>> updatePRofileDetail(UpdateUserParams photo) async {
    return await userProfileRemoteSource.updatePRofileDetail(photo);
  }

  @override
  Future<DataState<String>> addRemoveSupporters(
    AddRemoveSupporterParams params,
  ) async {
    return await userProfileRemoteSource.addRemoveSupporters(params);
  }

  @override
  Future<DataState<bool?>> deleteUser(String value) async {
    return await userProfileRemoteSource.deleteUser(value);
  }

  @override
  Future<DataState<bool?>> blockUser(BlockUserParams params) async {
    final DataState<bool?> result = await userProfileRemoteSource.blockUser(
      params,
    );

    // If block/unblock was successful, sync the full blocked users list from server
    if (result is DataSuccess<bool?>) {
      await _syncBlockedUsersFromServer();
    }

    return result;
  }

  /// Fetch blocked users from server and update local cache
  Future<void> _syncBlockedUsersFromServer() async {
    try {
      final DataState<List<UserEntity>> result = await getBlockedUsers();

      if (result is DataSuccess<List<UserEntity>>) {
        final List<UserEntity> blockedUsers = result.entity ?? <UserEntity>[];
        final List<String> blockedUserIds = blockedUsers
            .map((UserEntity user) => user.uid)
            .where((String? uid) => uid != null && uid.isNotEmpty)
            .cast<String>()
            .toList();

        await LocalBlockedUsers().replaceAll(blockedUserIds);
        AppLog.info(
          'Synced ${blockedUserIds.length} blocked users from server',
          name: 'UserProfileRepositoryImpl._syncBlockedUsersFromServer',
        );
      } else if (result is DataFailer) {
        AppLog.error(
          'Failed to sync blocked users from server: ${result.exception?.message}',
          name: 'UserProfileRepositoryImpl._syncBlockedUsersFromServer',
          error: result.exception,
        );
      }
    } catch (e, st) {
      AppLog.error(
        'Exception syncing blocked users: $e',
        name: 'UserProfileRepositoryImpl._syncBlockedUsersFromServer',
        stackTrace: st,
      );
    }
  }

  @override
  Future<DataState<List<UserEntity>>> getBlockedUsers() async {
    return await userProfileRemoteSource.getBlockedUsers();
  }
}
