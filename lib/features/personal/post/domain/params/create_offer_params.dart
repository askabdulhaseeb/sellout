class CreateOfferparams {
  CreateOfferparams(
    { required this.postId, required this.offerAmount, required this.currency, required this.quantity, required this.listId, this.color,
    this.size,
  });
  final String postId;
  final double offerAmount;
  final String currency;
  final int quantity;
  final String listId;
  final String? size;
  final String? color;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'offer_amount': offerAmount,
      'currency': currency,
      'list_id': listId,
      'quantity': quantity,
      'size': size,
      'color': color
    };
  }
}
