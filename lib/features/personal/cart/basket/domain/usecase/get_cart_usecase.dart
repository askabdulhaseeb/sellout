import '../../../../../../core/usecase/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUsecase implements UseCase<CartEntity, String> {
  const GetCartUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<CartEntity>> call(String param) async {
    return await _repository.getCart();
  }
}
