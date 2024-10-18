import '../../../../../../core/sources/data_state.dart';
import '../../domain/repositories/user_repositories.dart';
import '../models/user_model.dart';
import '../sources/remote/user_profile_remote_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this.userProfileRemoteSource);
  final UserProfileRemoteSource userProfileRemoteSource;
  @override
  Future<DataState<UserModel?>> byUID(String uid) async {
    return await userProfileRemoteSource.byUID(uid);
  }
}
