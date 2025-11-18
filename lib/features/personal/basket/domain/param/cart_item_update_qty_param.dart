import 'dart:convert';

import '../../data/sources/local/local_cart.dart';

class CartItemUpdateQtyParam {
  const CartItemUpdateQtyParam({
    required this.cartItem,
    required this.qty,
  });

  final CartItemEntity cartItem;
  final int qty;

  String updateQTY() => json.encode(<String, dynamic>{'quantity': qty});
}
