import 'package:hive/hive.dart';
import '../../../domain/entities/current_user_entity.dart';
import '../../../../../../../core/utilities/app_string.dart';
export '../../../domain/entities/current_user_entity.dart';

class LocalAuth {
  static final String boxTitle = AppStrings.localAuthBox;
  static Box<CurrentUserEntity> get _box =>
      Hive.box<CurrentUserEntity>(boxTitle);

  static Future<Box<CurrentUserEntity>> get openBox async =>
      await Hive.openBox<CurrentUserEntity>(boxTitle);

  Future<Box<CurrentUserEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<CurrentUserEntity>(boxTitle);
    }
  }

  Future<void> signin(CurrentUserEntity currentUser) async =>
      await _box.put(boxTitle, currentUser);
  static CurrentUserEntity? get currentUser =>
      _box.length == 0 ? null : _box.get(boxTitle);

  static String? get token => currentUser?.token;
  static String? get uid => currentUser?.userID;
  static String get currency => currentUser?.currency ?? 'gbp';

  Future<void> signout() async {
    await _box.clear();
  }
}
