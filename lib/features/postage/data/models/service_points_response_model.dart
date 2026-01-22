import '../../domain/entities/service_point_entity.dart';

/// Model for a service point from API response
class ServicePointModel extends ServicePointEntity {
  ServicePointModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.phone,
    super.workingHours,
  });

  factory ServicePointModel.fromJson(Map<String, dynamic> json) {
    return ServicePointModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: json['phone'] as String?,
      workingHours: json['workingHours'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'phone': phone,
    'workingHours': workingHours,
  };
}

/// Model for service points response from API
class ServicePointsResponseModel extends ServicePointsResponseEntity {
  ServicePointsResponseModel({required super.points, super.message});

  factory ServicePointsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> pointsJson = json['points'] as List<dynamic>? ?? [];
    final List<ServicePointEntity> points = pointsJson
        .map(
          (dynamic item) =>
              ServicePointModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return ServicePointsResponseModel(
      points: points,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'points': points.map((ServicePointEntity p) {
      if (p is ServicePointModel) {
        return p.toJson();
      }
      return <String, dynamic>{
        'id': p.id,
        'name': p.name,
        'address': p.address,
        'latitude': p.latitude,
        'longitude': p.longitude,
        'phone': p.phone,
        'workingHours': p.workingHours,
      };
    }).toList(),
    'message': message,
  };
}
