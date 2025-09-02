import 'package:hive/hive.dart';
part 'promo_entity.g.dart';

@HiveType(typeId: 56)
class PromoEntity {
  const PromoEntity({
    required this.promoId,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    required this.promoType,
    required this.isActive,
    required this.fileUrl,
    required this.referenceType,
    required this.referenceId,
    this.thumbnailUrl,
    this.views,
    this.price,
  });

  @HiveField(0)
  final String promoId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String createdBy;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final String promoType;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final String fileUrl;

  @HiveField(7)
  final String referenceType;

  @HiveField(8)
  final String referenceId;

  @HiveField(9)
  final String? thumbnailUrl;

  @HiveField(10)
  final List<dynamic>? views;

  @HiveField(11)
  final String? price;
}
