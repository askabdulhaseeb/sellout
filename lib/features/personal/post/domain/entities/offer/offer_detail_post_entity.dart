import 'package:hive/hive.dart';

import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../size_color/discount_entity.dart';
import '../size_color/size_color_entity.dart';
part 'offer_detail_post_entity.g.dart';

@HiveType(typeId: 20)
class OfferDetailPostEntity {
  const OfferDetailPostEntity({
    required this.quantity,
    required this.address,
    required this.isActive,
    required this.listId,
    required this.currentLongitude,
    required this.createdAt,
    required this.discount,
    required this.description,
    required this.fileUrls,
    required this.title,
    required this.type,
    required this.createdBy,
    required this.acceptOffers,
    required this.sizeColors,
    required this.currentLatitude,
    required this.postId,
    required this.deliveryType,
    required this.price,
    required this.minOfferAmount,
    required this.condition,
    required this.sizeChartUrl,
    required this.currency,
    required this.privacy,
    required this.brand,
  });

  @HiveField(0)
  final int quantity;
  @HiveField(1)
  final String address;
  @HiveField(2)
  final bool isActive;
  @HiveField(3)
  final String listId;
  @HiveField(4)
  final double currentLongitude;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DiscountEntity discount;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final List<AttachmentEntity> fileUrls;
  @HiveField(9)
  final String title;
  @HiveField(10)
  final String type;
  @HiveField(11)
  final String createdBy;
  @HiveField(12)
  final String acceptOffers;
  @HiveField(13)
  final List<SizeColorEntity> sizeColors;
  @HiveField(14)
  final double currentLatitude;
  @HiveField(15)
  final String postId;
  @HiveField(16)
  final DeliveryType deliveryType;
  @HiveField(17)
  final double price;
  @HiveField(18)
  final double minOfferAmount;
  @HiveField(19)
  final ConditionType condition;
  @HiveField(20)
  final String sizeChartUrl;
  @HiveField(21)
  final String currency;
  @HiveField(22)
  final PrivacyType privacy;
  @HiveField(23)
  final String brand;
}
