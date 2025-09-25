import 'package:hive_flutter/hive_flutter.dart';
part 'service_employee_entity.g.dart';

@HiveType(typeId: 78)
class ServiceEmployeeEntity {
  ServiceEmployeeEntity({
    required this.serviceId,
    required this.quantity,
    required this.bookAt,
  });
  @HiveField(1)
  final String serviceId;
  @HiveField(2)
  final int quantity;
  @HiveField(3)
  final String bookAt;
}
