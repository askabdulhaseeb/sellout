import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../domain/entities/offer/offer_detail_post_entity.dart';
import '../size_color/discount_model.dart';
import '../size_color/size_color_model.dart';

class OfferDetailPostModel extends OfferDetailPostEntity {
  OfferDetailPostModel({
    required super.quantity,
    required super.address,
    required super.isActive,
    required super.listId,
    required super.currentLongitude,
    required super.createdAt,
    required super.discount,
    required super.description,
    required super.fileUrls,
    required super.title,
    required super.type,
    required super.createdBy,
    required super.acceptOffers,
    required super.sizeColors,
    required super.currentLatitude,
    required super.postId,
    required super.deliveryType,
    required super.price,
    required super.minOfferAmount,
    required super.condition,
    required super.sizeChartUrl,
    required super.currency,
    required super.privacy,
    required super.brand,
  });

  factory OfferDetailPostModel.fromJson(Map<String, dynamic> json) =>
      OfferDetailPostModel(
        quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
        address: json['address'],
        isActive: json['is_active'],
        listId: json['list_id'],
        currentLongitude:
            double.tryParse(json['current_longitude']?.toString() ?? '0.0') ??
                0.0,
        createdAt: (json['created_at']?.toString() ?? '').toDateTime() ??
            DateTime.now(),
        discount: DiscountModel.fromJson(json['discount']),
        description: json['description'] ?? '',
        fileUrls:
            List<AttachmentModel>.from((json['file_urls'] ?? <dynamic>[]).map(
          (dynamic x) => AttachmentModel.fromJson(x),
        )),
        title: json['title'],
        type: json['type'],
        createdBy: json['created_by'],
        acceptOffers: json['accept_offers'],
        sizeColors:
            List<SizeColorModel>.from((json['size_colors'] ?? <dynamic>[]).map(
          (dynamic x) => SizeColorModel.fromJson(x),
        )),
        currentLatitude:
            double.tryParse(json['current_latitude']?.toString() ?? '0.0') ??
                0.0,
        postId: json['post_id'],
        deliveryType: DeliveryType.fromJson(json['delivery_type']),
        price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
        minOfferAmount:
            double.tryParse(json['min_offer_amount']?.toString() ?? '0.0') ??
                0.0,
        condition: ConditionType.fromJson(json['item_condition']),
        sizeChartUrl: json['size_chart_url'],
        currency: json['currency'],
        privacy: PrivacyType.fromJson(json['post_privacy']),
        brand: json['brand'] ?? '',
      );
}
