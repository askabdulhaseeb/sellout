import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/models/post/post_model.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';

abstract interface class PostByUserRemote {
  Future<DataState<List<PostEntity>>> getPostByUser(String? userId);
}

class PostByUserRemoteImpl implements PostByUserRemote {
  @override
  Future<DataState<List<PostEntity>>> getPostByUser(String? userId) async {
    try {
      //
      final String id = userId ?? LocalAuth.uid ?? '';
      if (id.isEmpty) {
        return DataFailer<List<PostEntity>>(CustomException('userId is empty'));
      }
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: 'post/query?created_by=$id',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        final dynamic userable = json.decode(raw);
        final List<dynamic> list = userable['items'];
        final List<PostEntity> posts = <PostEntity>[];
        for (dynamic element in list) {
          final PostEntity post = PostModel.fromJson(element);
          await LocalPost().save(post.postID, post);
          posts.add(post);
        }
        return DataSuccess<List<PostEntity>>(raw, posts);
      } else {
        return DataFailer<List<PostEntity>>(
          result.exception ?? CustomException('Failed to get post by user'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostByUserRemoteImpl.getPostByUser - catch',
        error: e,
      );
    }
    return DataFailer<List<PostEntity>>(
      CustomException('Failed to get post by user'),
    );
  }
}
