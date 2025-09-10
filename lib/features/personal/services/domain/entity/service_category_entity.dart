import 'package:hive/hive.dart';
import 'service_type_entity.dart';
part 'service_category_entity.g.dart';

@HiveType(typeId: 72)
class ServiceCategoryENtity {
  factory ServiceCategoryENtity.fromMap(Map<String, dynamic> map) {
    return ServiceCategoryENtity(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      serviceTypes: (map['service_types'] as List<dynamic>)
          .map((e) => ServiceTypeEntity.fromMap(e))
          .toList(),
    );
  }

  ServiceCategoryENtity({
    required this.label,
    required this.value,
    required this.category,
    required this.tags,
    required this.serviceTypes,
  });
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String value;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final List<ServiceTypeEntity> serviceTypes;

  Map<String, dynamic> toMap() => {
        'label': label,
        'value': value,
        'category': category,
        'tags': tags,
        'service_types': serviceTypes.map((e) => e.toMap()).toList(),
      };
}
