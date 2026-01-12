class OfferPaymentParams {
  const OfferPaymentParams({
    required this.postId,
    this.ratesKey,
    this.isOffer = false,
    this.offerId,
    this.messageId,
    this.chatId,
  });

  final String postId;
  final String? ratesKey;
  final bool isOffer;
  final String? offerId;
  final String? messageId;
  final String? chatId;

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
      map['message_id'] = messageId;
      map['chat_id'] = chatId;
    }
    return map;
  }
}
