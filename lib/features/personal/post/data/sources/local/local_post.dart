import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

import '../../../../../../core/sources/data_state.dart';
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

  DataState<PostEntity> dataState(String id) {
    final PostEntity? po = post(id);
    if (po == null) {
      return DataFailer<PostEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<PostEntity>('', po);
    }
  }

  List<PostEntity> get all => _box.values.toList();
}
