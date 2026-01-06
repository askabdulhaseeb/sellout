import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';

class BuyNowShippingRatesParams {
  const BuyNowShippingRatesParams({
    required this.postId,
    required this.buyerAddress,
    this.ratesKey,
    this.isOffer = false,
    this.offerId,
  });

  final String postId;
  final AddressEntity buyerAddress;
  final String? ratesKey;
  final bool isOffer;
  final String? offerId;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'post_id': postId,
      'buyer_address': AddressModel.fromEntity(buyerAddress).toShippingJson(),
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
