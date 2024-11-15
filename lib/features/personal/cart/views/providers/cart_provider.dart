import 'package:flutter/material.dart';

import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../data/models/cart_model.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecase/cart_item_status_update_usecase.dart';
import '../../domain/usecase/get_cart_usecase.dart';
import '../../domain/usecase/remove_from_cart_usecase.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._getCartUsecase, this._cartItemStatusUpdateUsecase,
      this._removeFromCartUsecase);
  final GetCartUsecase _getCartUsecase;
  final CartItemStatusUpdateUsecase _cartItemStatusUpdateUsecase;
  final RemoveFromCartUsecase _removeFromCartUsecase;

  List<CartItemEntity> _cartItems = <CartItemEntity>[];
  int _page = 1;
  int get page => _page;

  CartItemType _basketPage = CartItemType.cart;
  CartItemType get basketPage => _basketPage;

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
}
