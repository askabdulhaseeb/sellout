import '../../../domain/entities/post_entity.dart';

abstract interface class PostDetailRemoteApi {
  Future<PostEntity> getPost(String postId);
}
