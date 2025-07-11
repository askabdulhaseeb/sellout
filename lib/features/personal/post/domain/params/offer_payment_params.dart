import '../../../auth/signin/data/models/address_model.dart';

class OfferPaymentParams {
  OfferPaymentParams({
    required this.offerId,
    required this.buyerAddress,
  });
  final String offerId;
  final AddressModel buyerAddress;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offer_id': offerId,
      'buyer_address': buyerAddress.toOfferJson(),
    };
  }
}
