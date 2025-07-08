class UpdateOfferParams {
  UpdateOfferParams({
    required this.chatID,
    required this.messageId,
    required this.offerId,
    this.offerStatus,
    this.offerAmount,
    this.quantity,
    this.size,
    this.color,
  });

  final int? offerAmount;
  final int? quantity;
  final String? offerStatus;
  final String offerId;
  final String messageId;
  final String chatID;
  final String? size;
  final String? color;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'message_id': messageId,
    };

    if (offerAmount != null) map['offer_amount'] = offerAmount;
    if (quantity != null) map['quantity'] = quantity;
    if (offerStatus != null) map['offer_status'] = offerStatus;
    if (size != null && size!.isNotEmpty) map['size'] = size;
    if (color != null && color!.isNotEmpty) map['color'] = color;

    return map;
  }

  Map<String, dynamic> updateStatus() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (offerStatus != null) map['offer_status'] = offerStatus;
    return map;
  }
}
