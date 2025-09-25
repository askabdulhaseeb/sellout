import '../../domain/entites/service_employee_entity.dart';

class ServiceEmployeeModel extends ServiceEmployeeEntity {
  ServiceEmployeeModel({
    required super.serviceId,
    required super.quantity,
    required super.bookAt,
  });

  factory ServiceEmployeeModel.fromMap(Map<String, dynamic> map) {
    return ServiceEmployeeModel(
      serviceId: map['service_id'] ?? '',
      quantity: map['quantity'] ?? 0,
      bookAt: map['book_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service_id': serviceId,
      'quantity': quantity,
      'book_at': bookAt,
    };
  }
}
