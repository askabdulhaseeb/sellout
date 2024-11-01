import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../entities/user_entity.dart';

abstract interface class UserProfileRepository {
  Future<DataState<UserEntity?>> byUID(String uid);
  Future<DataState<List<PostEntity>>> getPostByUser(String? uid);
}
