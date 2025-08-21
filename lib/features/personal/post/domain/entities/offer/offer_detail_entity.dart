import 'package:hive/hive.dart';
import '../../../../../../core/enums/core/status_type.dart';
part 'offer_detail_entity.g.dart';

@HiveType(typeId: 19)
class OfferDetailEntity {
  OfferDetailEntity({
    required this.postTitle,
    required this.size,
    required this.color,
    required this.price,
    required this.minOfferAmount,
    required this.currency,
    required this.offerId,
    required this.offerPrice,
    required this.quantity,
    required this.buyerId,
    required this.sellerId,
    required this.postId,
    this.offerStatus,
  });

  @HiveField(0)
  final String postTitle;
  @HiveField(1)
  final String size;
  @HiveField(2)
  final String color;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final int minOfferAmount;
  @HiveField(6)
  StatusType? offerStatus;
  @HiveField(7)
  final String currency;
  @HiveField(8)
  final String offerId;
  @HiveField(9)
  int offerPrice;
  @HiveField(10)
  int quantity;
  @HiveField(11)
  final String buyerId;
  @HiveField(12)
  final String sellerId;
  @HiveField(13)
  final String postId;
}
