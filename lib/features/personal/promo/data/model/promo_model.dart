import '../../domain/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  const PromoModel({
    required super.title,
    required super.createdBy,
    required super.promoId,
    required super.promoType,
    required super.isActive,
    required super.createdAt,
    required super.fileUrl,
    required super.referenceType,
    required super.referenceId,
    super.thumbnailUrl,
    super.views,
    super.price,
  });

  factory PromoModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();
    if (map['created_at'] != null && map['created_at'] is String) {
      try {
        parsedDate = DateTime.parse(map['created_at']);
      } catch (_) {
        parsedDate = DateTime.now();
      }
    }
    return PromoModel(
      title: map['title'] ?? '',
      createdBy: map['created_by'] ?? '',
      promoId: map['promo_id'] ?? '',
      promoType: map['promo_type'] ?? '',
      isActive: map['is_active'] ?? false,
      createdAt: parsedDate,
      fileUrl: map['file_url'] ?? '',
      referenceType: map['reference_type'] ?? '',
      referenceId: map['reference_id'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
      views: map['views'] ?? <dynamic>[],
      price: map['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'created_by': createdBy,
      'promo_id': promoId,
      'promo_type': promoType,
      'is_active': isActive,
      'created_at': createdAt,
      'file_url': fileUrl,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'thumbnail_url': thumbnailUrl,
      'views': views,
      'price': price,
    };
  }
}
