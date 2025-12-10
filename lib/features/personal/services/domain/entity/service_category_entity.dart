import 'package:hive_ce/hive.dart';
import 'service_type_entity.dart';
part 'service_category_entity.g.dart';

@HiveType(typeId: 76)
class ServiceCategoryEntity {
  ServiceCategoryEntity({
    required this.label,
    required this.value,
    required this.imgURL,
    required this.category,
    required this.tags,
    required this.serviceTypes,
  });
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String value;

  @HiveField(2)
  final String imgURL;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final List<ServiceTypeEntity> serviceTypes;
}
