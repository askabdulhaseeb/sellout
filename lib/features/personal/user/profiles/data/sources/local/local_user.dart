import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../services/get_it.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/get_user_by_uid.dart';
export '../../models/user_model.dart';

class LocalUser extends LocalHiveBox<UserEntity> {
  @override
  String get boxName => AppStrings.localUsersBox;

  /// User profiles contain personal information - encrypt them.
  @override
  bool get requiresEncryption => true;

  UserEntity? userEntity(String value) => box.get(value);

  DataState<UserEntity?> userState(String value) {
    final UserEntity? entity = box.get(value);
    if (entity != null) {
      return DataSuccess<UserEntity?>(value, entity);
    } else {
      return DataFailer<UserEntity?>(CustomException('Loading...'));
    }
  }

  Future<UserEntity?> user(String id) async {
    final UserEntity? entity = userEntity(id);
    if (entity != null) {
      return entity;
    } else {
      final GetUserByUidUsecase getUserByUidUsecase = GetUserByUidUsecase(
        locator(),
      );
      final DataState<UserEntity?> user = await getUserByUidUsecase(id);
      if (user is DataSuccess) {
        return user.entity;
      } else {
        return null;
      }
    }
  }
}
