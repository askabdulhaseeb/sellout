enum BasketType {
  shoppingBasket,
  checkoutOrder,
  reviewOrder;

  String get code {
    switch (this) {
      case BasketType.shoppingBasket:
        return 'shopping_basket';
      case BasketType.checkoutOrder:
        return 'checkout_order';
      case BasketType.reviewOrder:
        return 'review_order';
    }
  }

  static List<BasketType> list() =>
      [shoppingBasket, checkoutOrder, reviewOrder];
}
