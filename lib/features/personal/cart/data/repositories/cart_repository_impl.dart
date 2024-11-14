import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../sources/cart_remote_api.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remoteAPI);
  final CartRemoteAPI _remoteAPI;
  
  @override
  Future<DataState<CartEntity>> getCart() async {
    return await _remoteAPI.getCart();
  }

  @override
  Future<void> addProductToCart() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<void> removeProductFromCart() {
    // TODO: implement removeProductFromCart
    throw UnimplementedError();
  }
}
