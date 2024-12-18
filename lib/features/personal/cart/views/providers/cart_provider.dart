import 'package:flutter/material.dart';

import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../data/models/cart/cart_model.dart';
import '../../domain/entities/cart/cart_entity.dart';
import '../../domain/entities/checkout/check_out_entity.dart';
import '../../domain/param/cart_item_update_qty_param.dart';
import '../../domain/usecase/cart/cart_item_status_update_usecase.dart';
import '../../domain/usecase/cart/cart_update_qty_usecase.dart';
import '../../domain/usecase/cart/get_cart_usecase.dart';
import '../../domain/usecase/cart/remove_from_cart_usecase.dart';
import '../../domain/usecase/checkout/get_checkout_usecase.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(
    this._getCartUsecase,
    this._cartItemStatusUpdateUsecase,
    this._removeFromCartUsecase,
    this._cartUpdateQtyUsecase,
    this._getCheckoutUsecase,
  );
  final GetCartUsecase _getCartUsecase;
  final CartItemStatusUpdateUsecase _cartItemStatusUpdateUsecase;
  final RemoveFromCartUsecase _removeFromCartUsecase;
  final CartUpdateQtyUsecase _cartUpdateQtyUsecase;
  final GetCheckoutUsecase _getCheckoutUsecase;

  List<CartItemEntity> _cartItems = <CartItemEntity>[];
  int _page = 1;
  int get page => _page;

  CartItemType _basketPage = CartItemType.cart;
  CartItemType get basketPage => _basketPage;

  AddressEntity? _address = (LocalAuth.currentUser?.address != null &&
          LocalAuth.currentUser!.address
              .where((AddressEntity element) => element.isDefault)
              .isNotEmpty)
      ? LocalAuth.currentUser!.address
          .where((AddressEntity element) => element.isDefault)
          .first
      : null;
  AddressEntity? get address => _address;

  set address(AddressEntity? value) {
    _address = value;
    notifyListeners();
  }

  set basketPage(CartItemType value) {
    _basketPage = value;
    notifyListeners();
  }

  List<CartItemEntity> get cartItems => _cartItems;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  Future<bool> getCart() async {
    if (_cartItems.isNotEmpty) {
      return true;
    }
    final DataState<CartEntity> satte = await _getCartUsecase('');
    if (satte is DataSuccess) {
      _cartItems = satte.entity?.items ?? <CartItemEntity>[];
    }
    notifyListeners();
    return true;
  }

  Future<DataState<CheckOutEntity>> checkout() async {
    try {
      if ((LocalAuth.currentUser?.address ?? <AddressEntity>[]).isEmpty) {
        return DataFailer<CheckOutEntity>(CustomException('message'));
      }
      _address ??= LocalAuth.currentUser?.address
          .where((AddressEntity element) => element.isDefault)
          .first;
      if (_address == null) {
        return DataFailer<CheckOutEntity>(CustomException('message'));
      }
      final DataState<CheckOutEntity> state =
          await _getCheckoutUsecase(_address!);
      return state;
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.checkout - Catch',
        error: e,
      );
      return DataFailer<CheckOutEntity>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> updateStatus(CartItemEntity value) async {
    try {
      return await _cartItemStatusUpdateUsecase(
          CartItemModel.fromEntity(value));
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.updateStatus - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> removeItem(String id) async {
    try {
      return await _removeFromCartUsecase(id);
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.removeItem - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  Future<DataState<bool>> updateQty(CartItemEntity cartItem, int qty) async {
    try {
      return await _cartUpdateQtyUsecase(
        CartItemUpdateQtyParam(
          cartItem: cartItem,
          qty: qty,
        ),
      );
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CartProvider.updateQty - Catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
