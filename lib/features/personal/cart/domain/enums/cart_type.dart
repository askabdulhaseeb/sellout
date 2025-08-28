enum CartType {
  basket,
  saved,
  buyAgain;

  String get code {
    switch (this) {
      case CartType.basket:
        return 'basket';
      case CartType.saved:
        return 'saved';
      case CartType.buyAgain:
        return 'buy_again';
    }
  }

  static List<CartType> list() => [basket, saved, buyAgain];
}
