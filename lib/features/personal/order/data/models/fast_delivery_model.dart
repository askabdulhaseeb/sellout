import '../../domain/entities/fast_delivery_entity.dart';

class FastDeliveryModel extends FastDeliveryEntity {
  FastDeliveryModel({required super.available, super.message, super.requested});

  factory FastDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryModel(
      available: json['available'],
      message: json['message'],
      requested: json['requested'],
    );
  }

  factory FastDeliveryModel.fromEntity(FastDeliveryEntity e) {
    return FastDeliveryModel(
      available: e.available,
      message: e.message,
      requested: e.requested,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'available': available,
      'message': message,
      'requested': requested,
    };
  }
}
