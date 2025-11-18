import '../../../domain/entities/post/post_entity.dart';

abstract interface class PostDetailRemoteApi {
  Future<PostEntity> getPost(String postId);
}
