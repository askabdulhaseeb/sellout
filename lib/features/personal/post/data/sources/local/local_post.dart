import 'package:hive/hive.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../models/post_model.dart';

class LocalPost {
  static final String boxTitle = AppStrings.localPostsBox;
  static Box<PostModel> get _box => Hive.box<PostModel>(boxTitle);

  static Future<Box<PostModel>> get openBox async =>
      await Hive.openBox<PostModel>(boxTitle);

  Future<Box<PostModel>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<PostModel>(boxTitle);
    }
  }

  Future<void> save(PostModel value) async =>
      await _box.put(value.postId, value);

  PostModel? post(String id) => _box.get(id);
}
