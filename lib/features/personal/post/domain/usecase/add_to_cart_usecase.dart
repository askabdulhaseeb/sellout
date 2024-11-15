import '../../../../../core/usecase/usecase.dart';
import '../params/add_to_cart_param.dart';
import '../repositories/post_repository.dart';

class AddToCartUsecase implements UseCase<bool, AddToCartParam> {
  const AddToCartUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(AddToCartParam post) async {
    return await repository.addToCart(post);
  }
}
