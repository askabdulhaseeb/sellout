import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/sources/api_call.dart';
import '../../data/models/cart/cart_model.dart';
import '../entities/cart/cart_entity.dart';
import '../param/cart_item_update_qty_param.dart';

abstract interface class CartRepository {
  Future<void> addProductToCart();
  Future<DataState<bool>> removeProductFromCart(String id);
  Future<void> clearCart();
  Future<DataState<CartEntity>> getCart();
  Future<DataState<bool>> updateQty(CartItemUpdateQtyParam param);
  Future<DataState<bool>> updateStatus(
      CartItemModel params, CartItemType action);
}
