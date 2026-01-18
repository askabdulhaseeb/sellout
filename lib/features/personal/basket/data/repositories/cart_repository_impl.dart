import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/param/cart_item_update_qty_param.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart/cart_model.dart';
import '../sources/remote/cart_remote_api.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._remoteAPI);
  final CartRemoteAPI _remoteAPI;

  @override
  Future<DataState<CartEntity>> getCart() async {
    return await _remoteAPI.getCart();
  }

  @override
  Future<void> addProductToCart() async {
    await _remoteAPI.addProductToCart();
  }

  @override
  Future<void> clearCart() async {
    await _remoteAPI.clearCart();
  }

  @override
  Future<DataState<bool>> removeProductFromCart(String id) async {
    return await _remoteAPI.removeProductFromCart(id);
  }

  @override
  Future<DataState<bool>> updateStatus(
    CartItemModel params,
    CartItemStatusType action,
  ) async {
    return await _remoteAPI.updateStatus(params, action);
  }

  @override
  Future<DataState<bool>> updateQty(CartItemUpdateQtyParam param) async {
    return await _remoteAPI.updateQty(param);
  }


}
