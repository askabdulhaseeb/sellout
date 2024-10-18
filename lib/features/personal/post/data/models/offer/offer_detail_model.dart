import 'dart:developer';

import '../../../domain/entities/offer/offer_detail_entity.dart';
import 'offer_detail_post_model.dart';

class OfferDetailModel extends OfferDetailEntity {
  const OfferDetailModel({
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
  });

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) {
    log('OfferDetailModel.fromJson - Title: ${json['post_title']}');
    return OfferDetailModel(
      postTitle: json['post_title'],
      size: json['size'],
      color: json['color'],
      post: OfferDetailPostModel.fromJson(json['post']),
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      minOfferAmount:
          int.tryParse(json['min_offer_amount']?.toString() ?? '0') ?? 0,
      offerStatus: json['offer_status'],
      currency: json['currency'],
      offerId: json['offer_id'],
      offerPrice: int.tryParse(json['offer_price']?.toString() ?? '0') ?? 0,
    );
  }
}
