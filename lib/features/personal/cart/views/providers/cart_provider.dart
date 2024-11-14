import 'package:flutter/material.dart';

import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecase/get_cart_usecase.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._getCartUsecase);
  final GetCartUsecase _getCartUsecase;

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
      _cartItems = satte.entity?.cartItems ?? <CartItemEntity>[];
    }
    notifyListeners();
    return true;
  }
}
