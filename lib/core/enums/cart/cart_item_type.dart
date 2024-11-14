enum CartItemType {
  cart('cart', 'cart'),
  saveLater('save-later', 'save_later');

  // Add the following line:
  const CartItemType(this.code, this.json);
  final String code;
  final String json;

  static CartItemType fromJson(String json) {
    return CartItemType.values.firstWhere(
      (CartItemType e) => e.json == json,
      orElse: () => CartItemType.cart,
    );
  }

  static List<CartItemType> get list => values.toList();

  static List<String> get codeList => values.map((CartItemType e) => e.code).toList();
}
