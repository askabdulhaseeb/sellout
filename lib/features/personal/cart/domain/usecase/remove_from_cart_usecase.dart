import '../../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartUsecase implements UseCase<bool, String> {
  const RemoveFromCartUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<bool>> call(String id) async {
    return await _repository.removeProductFromCart(id);
  }
}
