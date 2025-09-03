import '../../../domain/entities/post/post_property_entity.dart';

class PostPropertyModel extends PostPropertyEntity {
  PostPropertyModel({
    required super.bedroom,
    required super.bathroom,
    required super.energyRating,
    required super.propertyType,
    required super.propertyCategory,
    required super.garden,
    required super.parking,
    required super.tenureType,
  });

  factory PostPropertyModel.fromJson(Map<String, dynamic> json) {
    return PostPropertyModel(
      bedroom: json['bedrooms'] ?? 0,
      bathroom: json['bathrooms'] ?? 0,
      energyRating: json['energy_rating']?.toString(),
      propertyType: json['property_type']?.toString(),
      propertyCategory: json['property_category']?.toString(),
      garden: json['garden'] ?? false,
      parking: json['parking'] ?? true,
      tenureType: json['tenure_type']?.toString(),
    );
  }
}
