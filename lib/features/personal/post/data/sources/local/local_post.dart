import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecase/get_specific_post_usecase.dart';

class LocalPost {
  static final String boxTitle = AppStrings.localPostsBox; // this is key
  static Box<PostEntity> get _box => Hive.box<PostEntity>(boxTitle); // box

  static Future<Box<PostEntity>> get openBox async =>
      await Hive.openBox<PostEntity>(boxTitle); // open box

  Future<Box<PostEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<PostEntity>(boxTitle);
    } // refresh function  chekc if box is not open
  }

  Future<void> save(PostEntity value) async {
    await _box.put(value.postID, value);
  } // according to requiremnts

  Future<void> saveAll(List<PostEntity> posts) async {
    final Map<String, PostEntity> map = <String, PostEntity>{
      for (PostEntity post in posts) post.postID: post,
    };
    await _box.putAll(map);
  }

  Future<void> clear() async => await _box.clear(); // clear functon to sign out

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

  Future<PostEntity?> getPost(String id) async {
    final PostEntity? po = post(id);
    if (po == null) {
      final GetSpecificPostUsecase getSpecificPostUsecase =
          GetSpecificPostUsecase(locator());
      final DataState<PostEntity> result = await getSpecificPostUsecase(
        GetSpecificPostParam(postId: id, silentUpdate: true),
      );
      if (result is DataSuccess) {
        return result.entity;
      } else {
        return null;
      }
    } else {
      return po;
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
