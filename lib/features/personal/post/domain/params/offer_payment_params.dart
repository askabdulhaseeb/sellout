class OfferPaymentParams {
  const OfferPaymentParams({
    required this.postId,
    this.ratesKey,
    this.isOffer = false,
    this.offerId,
  });

  final String postId;
  final String? ratesKey;
  final bool isOffer;
  final String? offerId;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{ 
      'post_id': postId,
      'is_offer': isOffer,
    };
    if (ratesKey != null && ratesKey!.isNotEmpty) {
      map['rates_key'] = ratesKey;
    }
    if (isOffer && offerId != null && offerId!.isNotEmpty) {
      map['offer_id'] = offerId;
    }
    return map;
  }
}
