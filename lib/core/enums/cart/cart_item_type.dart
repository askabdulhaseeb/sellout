enum CartItemType {
  cart('cart', 'cart', 'save-later'),
  saveLater('save-later', 'save_later', 'move-to-cart');

  // Add the following line:
  const CartItemType(this.code, this.json, this.tileActionCode);
  final String code;
  final String json;
  final String tileActionCode;

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
