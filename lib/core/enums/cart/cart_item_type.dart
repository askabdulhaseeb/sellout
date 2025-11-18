enum CartItemStatusType {
  cart('cart', 'cart', 'save_later', 'add_cart'),
  saveLater('save_later', 'save_later', 'move_to_cart', 'save_later');

  const CartItemStatusType(this.code, this.json, this.tileActionCode, this.action);
  final String code;
  final String json;
  final String tileActionCode;
  final String action;

  static CartItemStatusType fromJson(String json) {
    return CartItemStatusType.values.firstWhere(
      (CartItemStatusType e) => e.json == json,
      orElse: () => CartItemStatusType.cart,
    );
  }

  static List<CartItemStatusType> get list => values.toList();
  static List<String> get codeList =>
      values.map((CartItemStatusType e) => e.code).toList();
}


