import 'package:hive/hive.dart';
part 'promo_entity.g.dart';

@HiveType(typeId: 56)
class PromoEntity {


  const PromoEntity({
    required this.title,
    required this.createdBy,
    required this.promoId,
    required this.promoType,
    required this.isActive,
    required this.createdAt,
    required this.fileUrl,
     this.views, this.thumbnailUrl,
    this.price,
  });
@HiveField(0)
  final String title;

  @HiveField(1)
  final String createdBy;

  @HiveField(2)
  final String promoId;

  @HiveField(3)
  final String promoType;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final String createdAt;

  @HiveField(6)
  final String fileUrl;

  @HiveField(7)
  final String? thumbnailUrl;

  @HiveField(8)
  final List<dynamic>? views;
  @HiveField(9)
  final String? price;
  
}
