import 'package:hive/hive.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/post_entity.dart';

class LocalPost {
  static final String boxTitle = AppStrings.localPostsBox;
  static Box<PostEntity> get _box => Hive.box<PostEntity>(boxTitle);

  static Future<Box<PostEntity>> get openBox async =>
      await Hive.openBox<PostEntity>(boxTitle);

  Future<Box<PostEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<PostEntity>(boxTitle);
    }
  }

  Future<void> save(PostEntity value) async =>
      await _box.put(value.postId, value);

  PostEntity? post(String id) => _box.get(id);

  List<PostEntity> get all => _box.values.toList();
}
