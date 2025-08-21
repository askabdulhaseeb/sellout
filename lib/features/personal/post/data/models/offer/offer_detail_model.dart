import '../../../../../../core/enums/core/status_type.dart';
import '../../../domain/entities/offer/offer_detail_entity.dart';

class OfferDetailModel extends OfferDetailEntity {
  OfferDetailModel({
    required super.postTitle,
    required super.size,
    required super.color,
    required super.price,
    required super.minOfferAmount,
    required super.offerStatus,
    required super.currency,
    required super.offerId,
    required super.offerPrice,
    required super.buyerId,
    required super.sellerId,
    required super.quantity,
    required super.postId,
  });

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) {
    return OfferDetailModel(
      postTitle: json['post_title'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      minOfferAmount:
          int.tryParse(json['min_offer_amount']?.toString() ?? '0') ?? 0,
      offerStatus: StatusType.fromJson(json['offer_status']),
      currency: json['currency'] ?? '',
      offerId: json['offer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      offerPrice: int.tryParse(json['offer_price']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] ?? 1,
      postId: json['post_id'] ?? '',
    );
  }
}
