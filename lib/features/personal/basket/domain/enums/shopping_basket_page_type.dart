enum CartType {
  shoppingBasket,
  checkoutOrder,
  reviewOrder,
  payment;

  String get code {
    switch (this) {
      case CartType.shoppingBasket:
        return 'shopping_basket';
      case CartType.checkoutOrder:
        return 'checkout_order';
      case CartType.reviewOrder:
        return 'review_order';
      case CartType.payment:
        return 'payment';
    }
  }

  static List<CartType> list() =>
      <CartType>[shoppingBasket, checkoutOrder, reviewOrder, payment];
}
