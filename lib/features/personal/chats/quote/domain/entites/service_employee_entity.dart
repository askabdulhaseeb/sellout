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
  String serviceId;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String bookAt;

  /// 🔹 copyWith method
  ServiceEmployeeEntity copyWith({
    String? serviceId,
    int? quantity,
    String? bookAt,
  }) {
    return ServiceEmployeeEntity(
      serviceId: serviceId ?? this.serviceId,
      quantity: quantity ?? this.quantity,
      bookAt: bookAt ?? this.bookAt,
    );
  }
}
