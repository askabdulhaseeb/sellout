import 'package:hive/hive.dart';

import '../post_entity.dart';
part 'offer_detail_entity.g.dart';

@HiveType(typeId: 19)
class OfferDetailEntity {
  OfferDetailEntity({
    required this.postTitle,
    required this.size,
    required this.color,
    required this.post,
    required this.price,
    required this.minOfferAmount,
    required this.currency, required this.offerId, required this.offerPrice, this.offerStatus,
  });

  @HiveField(0)
  final String postTitle;
  @HiveField(1)
  final String size;
  @HiveField(2)
  final String color;
  @HiveField(3)
  final PostEntity post;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final int minOfferAmount;
  @HiveField(6)
  String? offerStatus;
  @HiveField(7)
  final String currency;
  @HiveField(8)
  final String offerId;
  @HiveField(9)
   int offerPrice;
}
