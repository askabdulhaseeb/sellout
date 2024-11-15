import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';

class CartItemStatusUpdateUsecase implements UseCase<bool, CartItemModel> {
  const CartItemStatusUpdateUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<bool>> call(CartItemModel params) async {
    return await _repository.updateStatus(
      params,
      params.inCart ? CartItemType.saveLater : CartItemType.cart,
    );
  }
}
