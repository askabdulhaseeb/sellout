enum CartItemType {
  cart('cart', 'cart', 'save_later', 'add_cart'),
  saveLater('save_later', 'save_later', 'move_to_cart', 'save_later');

  // Add the following line:
  const CartItemType(this.code, this.json, this.tileActionCode, this.action);
  final String code;
  final String json;
  final String tileActionCode;
  final String action;

  static CartItemType fromJson(String json) {
    return CartItemType.values.firstWhere(
      (CartItemType e) => e.json == json,
      orElse: () => CartItemType.cart,
    );
  }

  static List<CartItemType> get list => values.toList();

  static List<String> get codeList =>
      values.map((CartItemType e) => e.code).toList();
}
