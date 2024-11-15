import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../entities/post_entity.dart';
import '../params/add_to_cart_param.dart';

abstract interface class PostRepository {
  Future<DataState<List<PostEntity>>> getFeed();
  Future<DataState<PostEntity>> getPost(String id, {bool silentUpdate = true});
  Future<DataState<bool>> addToCart(AddToCartParam param);
}
