import '../../../../../core/usecase/usecase.dart';
import '../param/cart_item_update_qty_param.dart';
import '../repositories/cart_repository.dart';

class CartUpdateQtyUsecase implements UseCase<bool, CartItemUpdateQtyParam> {
  const CartUpdateQtyUsecase(this._repository);
  final CartRepository _repository;

  @override
  Future<DataState<bool>> call(CartItemUpdateQtyParam param) async {
    return await _repository.updateQty(param);
  }
}
