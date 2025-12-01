import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/usecase/get_specific_post_usecase.dart';

class LocalPost {
  /// Always fetches a fresh post from remote, does not use local cache.
  Future<DataState<PostEntity>> getFreshPost(
    String id
  ) async {
    try {
      final GetSpecificPostUsecase getSpecificPostUsecase =
          GetSpecificPostUsecase(locator());
      final DataState<PostEntity> result = await getSpecificPostUsecase(
        GetSpecificPostParam(postId: id, silentUpdate: false),
      );
      return result;
    } catch (e) {
      return DataFailer<PostEntity>(CustomException(e.toString()));
    }
  }

  static final String boxTitle = AppStrings.localPostsBox;
  static Box<PostEntity> get _box => Hive.box<PostEntity>(boxTitle); // box

  static Future<Box<PostEntity>> get openBox async =>
      await Hive.openBox<PostEntity>(boxTitle);

  Future<Box<PostEntity>> refresh() async {
    try {
      final bool isOpen = Hive.isBoxOpen(boxTitle);
      final Box<PostEntity> box = isOpen
          ? _box
          : await Hive.openBox<PostEntity>(boxTitle);

      // Check for type errors in all posts and remove faulty ones
      final List<String> faultyKeys = <String>[];
      for (final String key in box.keys.cast<String>()) {
        try {
          final PostEntity? post = box.get(key);
          // Try to access a required field to trigger type errors
          if (post == null) {
            faultyKeys.add(key);
          }
        } catch (_) {
          faultyKeys.add(key);
        }
      }
      if (faultyKeys.isNotEmpty) {
        await box.deleteAll(faultyKeys);
      }
      return box;
    } catch (e) {
      // If opening the box fails due to a type error, delete the box file and recreate
      try {
        await Hive.deleteBoxFromDisk(boxTitle);
      } catch (_) {}
      return await Hive.openBox<PostEntity>(boxTitle);
    }
  }

  Future<void> save(PostEntity value) async {
    await _box.put(value.postID, value);
  }

  Future<void> saveAll(List<PostEntity> posts) async {
    final Map<String, PostEntity> map = <String, PostEntity>{
      for (PostEntity post in posts) post.postID: post,
    };
    await _box.putAll(map);
  }

  Future<void> clear() async => await _box.clear();

  PostEntity? post(String id) => _box.get(id);

  List<PostEntity> get all => _box.values.toList();

  DataState<PostEntity> dataState(String id) {
    final PostEntity? po = post(id);
    if (po == null) {
      return DataFailer<PostEntity>(CustomException('loading...'.tr()));
    } else {
      return DataSuccess<PostEntity>('', po);
    }
  }

  Future<PostEntity?> getPost(String id, {bool? silentUpdate}) async {
    try {
      final PostEntity? po = post(id);
      if (po == null) {
        final GetSpecificPostUsecase getSpecificPostUsecase =
            GetSpecificPostUsecase(locator());
        final DataState<PostEntity> result = await getSpecificPostUsecase(
          GetSpecificPostParam(postId: id, silentUpdate: silentUpdate ?? true),
        );
        if (result is DataSuccess) {
          return result.entity;
        } else {
          return null;
        }
      } else {
        return po;
      }
    } catch (e) {
      try {
        await _box.delete(id);
      } catch (_) {}
      return null;
    }
  }

  DataState<List<PostEntity>> postbyUid(String? value) {
    final String id = value ?? LocalAuth.uid ?? '';
    if (id.isEmpty) {
      return DataFailer<List<PostEntity>>(CustomException('userId is empty'));
    }
    final List<PostEntity> posts = _box.values.where((PostEntity post) {
      return post.createdBy == id;
    }).toList();
    if (posts.isEmpty) {
      return DataFailer<List<PostEntity>>(CustomException('No post found'));
    } else {
      return DataSuccess<List<PostEntity>>('', posts);
    }
  }

  DataState<List<PostEntity>> postbyBusinessID(String? value) {
    final String id = value ?? '';
    if (id.isEmpty) {
      return DataFailer<List<PostEntity>>(CustomException('userId is empty'));
    }
    final List<PostEntity> posts = _box.values.where((PostEntity post) {
      return post.businessID == id;
    }).toList();
    if (posts.isEmpty) {
      return DataFailer<List<PostEntity>>(CustomException('No post found'));
    } else {
      return DataSuccess<List<PostEntity>>('', posts);
    }
  }
}
