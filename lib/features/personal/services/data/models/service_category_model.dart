import '../../domain/entity/service_category_entity.dart';
import 'service_type_model.dart';

/// Model that extends ServiceCategoryEntity
class ServiceCategoryModel extends ServiceCategoryEntity {
  ServiceCategoryModel({
    required super.label,
    required super.value,
    required super.imgURL,
    required super.category,
    required super.tags,
    required super.serviceTypes,
  });

  factory ServiceCategoryModel.fromMap(Map<String, dynamic> map) {
    return ServiceCategoryModel(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
      imgURL: map['img_url'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? <dynamic>[]),
      serviceTypes: (map['service_types'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => ServiceTypeModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
