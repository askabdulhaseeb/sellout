import '../../../../../../core/sources/data_state.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repositories.dart';
import '../sources/remote/my_visting_remote.dart';
import '../sources/remote/post_by_user_remote.dart';
import '../sources/remote/user_profile_remote_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(
    this.userProfileRemoteSource,
    this.postByUserRemote,
    this.myVisitingRemote,
  );
  final UserProfileRemoteSource userProfileRemoteSource;
  final PostByUserRemote postByUserRemote;
  final MyVisitingRemote myVisitingRemote;

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
}
