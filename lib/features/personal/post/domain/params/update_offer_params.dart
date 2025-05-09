class UpdateOfferParams {
  UpdateOfferParams({
    required this.chatID,
    required this.offerStatus,
    required this.messageId,
    required this.offerId,
    required this.businessId,
    required this.offerAmount,
    required this.quantity,
    required this.minOffer,
    required this.size,
    required this.color,
  });
  final int? offerAmount;
  final int? quantity;
  final int? minOffer;
  final String offerStatus;
  final String offerId;
  final String businessId;
  final String messageId;
  final String chatID;
  final String size;
  final String color;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offer_amount': offerAmount,
      'offer_status': offerStatus,
      'business_id': businessId,
      'message_id': messageId,
      'quantity': quantity,
      if (size != '') 'size': size,
      if (color != '') 'color': color
    };
  }

  Map<String, dynamic> updateStatus() {
    return <String, dynamic>{
      'offer_status': offerStatus,
    };
  }
}
