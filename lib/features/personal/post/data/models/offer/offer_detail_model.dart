import '../../../domain/entities/offer/offer_detail_entity.dart';
import '../post_model.dart';

class OfferDetailModel extends OfferDetailEntity {
  OfferDetailModel({
    required super.postTitle,
    required super.size,
    required super.color,
    required super.post,
    required super.price,
    required super.minOfferAmount,
    required super.offerStatus,
    required super.currency,
    required super.offerId,
    required super.offerPrice,
    required super.quantity,
  });

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) {
    return OfferDetailModel(
      postTitle: json['post_title'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      post: PostModel.fromJson(json['post'] ?? <String, dynamic>{}),
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      minOfferAmount:
          int.tryParse(json['min_offer_amount']?.toString() ?? '0') ?? 0,
      offerStatus: json['offer_status'] ?? '',
      currency: json['currency'] ?? '',
      offerId: json['offer_id'] ?? '',
      offerPrice: int.tryParse(json['offer_price']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }
}
