import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/usecase/get_specific_post_usecase.dart';

class LocalPost extends LocalHiveBox<PostEntity> {
  @override
  String get boxName => AppStrings.localPostsBox;

  Future<DataState<PostEntity>> getFreshPost(String id) async {
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

  static Box<PostEntity> get _box =>
      Hive.box<PostEntity>(AppStrings.localPostsBox); // box

  static Future<Box<PostEntity>> get openBox async =>
      await Hive.openBox<PostEntity>(AppStrings.localPostsBox);

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
