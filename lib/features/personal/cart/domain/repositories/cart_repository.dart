import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/sources/api_call.dart';
import '../../data/models/cart_model.dart';
import '../entities/cart_entity.dart';

abstract interface class CartRepository {
  Future<void> addProductToCart();
  Future<void> removeProductFromCart();
  Future<void> clearCart();
  Future<DataState<CartEntity>> getCart();
  Future<DataState<bool>> updateStatus(CartItemModel params, CartItemType action);
}
