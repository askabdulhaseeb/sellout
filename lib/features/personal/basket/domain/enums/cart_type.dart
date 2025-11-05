enum ShoppingBasketPageType {
  basket,
  saved,
  buyAgain;

  String get code {
    switch (this) {
      case ShoppingBasketPageType.basket:
        return 'basket';
      case ShoppingBasketPageType.saved:
        return 'saved';
      case ShoppingBasketPageType.buyAgain:
        return 'buy_again';
    }
  }

  static List<ShoppingBasketPageType> list() => [basket, saved, buyAgain];
}
