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

  // Map representation for request params (values as strings)
  Map<String, String> toParamMap() => <String, String>{
        'bedrooms': bedroom?.toString() ?? '',
        'bathrooms': bathroom?.toString() ?? '',
        'energy_rating': energyRating ?? '',
        'property_type': propertyType ?? '',
        'property_category': propertyCategory ?? '',
        'garden': garden.toString(),
        'parking': parking.toString(),
        'tenure_type': tenureType ?? '',
      };
}
