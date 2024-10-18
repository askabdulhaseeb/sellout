import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../models/user_model.dart';

export '../../models/user_model.dart';

class LocalUser {
  static final String boxTitle = AppStrings.localUsersBox;
  static Box<UserModel> get _box => Hive.box<UserModel>(boxTitle);

  static Future<Box<UserModel>> get openBox async =>
      await Hive.openBox<UserModel>(boxTitle);

  Future<Box<UserModel>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<UserModel>(boxTitle);
    }
  }

  Future<void> save(UserModel user) async => await _box.put(user.uid, user);
  UserModel? userEntity(String value) => _box.get(value);

  DataState<UserModel?> userState(String value) {
    final UserModel? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<UserModel?>(value, entity);
    } else {
      return DataFailer<UserModel?>(CustomException('Loading...'));
    }
  }
}
