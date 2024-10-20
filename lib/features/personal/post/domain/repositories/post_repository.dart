import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../entities/post_entity.dart';

abstract interface class PostRepository {
  Future<DataState<List<PostEntity>>> getFeed();
  Future<DataState<PostEntity>> getPost(String id, {bool silentUpdate = true});
}
