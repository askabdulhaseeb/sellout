import '../../../../../core/sources/api_call.dart';
import '../entities/cart_entity.dart';

abstract interface class CartRepository {
  Future<void> addProductToCart();
  Future<void> removeProductFromCart();
  Future<void> clearCart();
  Future<DataState<CartEntity>> getCart();
}
