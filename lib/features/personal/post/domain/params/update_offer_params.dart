class UpdateOfferParams {
  UpdateOfferParams({
    required this.chatID,
    required this.messageId,
    required this.offerId,
    required this.currency,
    this.offerStatus,
    this.offerAmount,
    this.quantity,
    this.size,
    this.color,
    this.counterOffer = false,
  });

  final int? offerAmount;
  final int? quantity;
  final String? offerStatus;
  final String offerId;
  final String messageId;
  final String chatID;
  final String? size;
  final String? color;
  final bool counterOffer;
  final String currency;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'message_id': messageId,
    };

    if (offerAmount != null) map['offer_amount'] = offerAmount;
    if (chatID != '') map['chat_id'] = chatID;
    if (currency != '') map['currency'] = currency;
    if (quantity != null) map['quantity'] = quantity;
    if (offerStatus != null) map['offer_status'] = offerStatus;
    if (size != null && size!.isNotEmpty) map['size'] = size;
    if (color != null && color!.isNotEmpty) map['color'] = color;
    if (counterOffer == true) map['counter_offer'] = true;
    return map;
  }

  Map<String, dynamic> updateStatus() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (offerStatus != null) map['offer_status'] = offerStatus;
    return map;
  }
}
