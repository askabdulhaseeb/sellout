import 'package:hive_ce/hive.dart';
part 'service_type_entity.g.dart';

@HiveType(typeId: 77)
class ServiceTypeEntity {
  ServiceTypeEntity({required this.value, required this.label});

  factory ServiceTypeEntity.fromMap(Map<String, dynamic> map) {
    return ServiceTypeEntity(
      value: map['value'] ?? '',
      label: map['label'] ?? '',
    );
  }
  @HiveField(0)
  final String value;

  @HiveField(1)
  final String label;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'value': value,
    'label': label,
  };
}
