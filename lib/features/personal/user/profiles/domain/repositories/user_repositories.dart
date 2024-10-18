import '../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../entities/user_entity.dart';

abstract interface class UserProfileRepository {
  Future<DataState<UserEntity?>> byUID(String uid);
}
