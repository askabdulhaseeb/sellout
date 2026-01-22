/// Entity representing a service point for pickup
class ServicePointEntity {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? workingHours;

  ServicePointEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.workingHours,
  });
}

/// Response entity containing list of service points
class ServicePointsResponseEntity {
  final List<ServicePointEntity> points;
  final String? message;

  ServicePointsResponseEntity({required this.points, this.message});
}
