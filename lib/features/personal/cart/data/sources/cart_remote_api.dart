import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';

import '../models/cart_item_model.dart';
import 'local_cart.dart';

abstract interface class CartRemoteAPI {
  Future<DataState<CartEntity>> getCart();
  Future<void> addProductToCart();
  Future<void> removeProductFromCart();
  Future<void> clearCart();
}

class CartRemoteAPIImpl implements CartRemoteAPI {
  @override
  Future<DataState<CartEntity>> getCart() async {
    try {
      //
      const String endpoint = '/cart/get';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );
      if (result is DataSuccess<bool>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataSuccess<CartEntity>(raw, CartModel());
        }
        final CartModel cartModel = CartModel.fromRaw(raw);
        AppLog.info(
          'CartRemoteAPIImpl.getCart - Cart Item Length: ${cartModel.cartItems.length}',
          name: 'CartRemoteAPIImpl.getCart - Success',
        );
        LocalCart().save(cartModel);
        return DataSuccess<CartEntity>(raw, cartModel);
      } else {
        AppLog.error(
          'Failed to get cart',
          name: 'CartRemoteAPIImpl.getCart - Else',
        );
        return DataFailer<CartEntity>(CustomException('Failed to get cart'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.getCart - Catch',
        error: e,
      );
      return DataFailer<CartEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<void> addProductToCart() async {
    try {
      //
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.addProductToCart - Catch',
        error: e,
      );
    }
    // TODO: implement addProductToCart
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() async {
    try {
      //
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.clearCart - Catch',
        error: e,
      );
    }
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<void> removeProductFromCart() async {
    try {
      //
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartRemoteAPIImpl.removeProductFromCart - Catch',
        error: e,
      );
    }
    // TODO: implement removeProductFromCart
    throw UnimplementedError();
  }
}
