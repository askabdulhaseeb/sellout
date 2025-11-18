import '../../domain/entity/service_type_entity.dart';

/// Model that extends ServiceTypeEntity
class ServiceTypeModel extends ServiceTypeEntity {
  ServiceTypeModel({
    required super.value,
    required super.label,
  });

  factory ServiceTypeModel.fromMap(Map<String, dynamic> map) {
    return ServiceTypeModel(
      value: map['value'] ?? '',
      label: map['label'] ?? '',
    );
  }
}
