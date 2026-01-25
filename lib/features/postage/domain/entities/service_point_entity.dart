/// Entity representing item dimensions
class ItemDimensionsEntity {
  final double length;
  final double width;
  final double height;
  final double weight;

  ItemDimensionsEntity({
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });
}

/// Entity representing a service point for pickup
class ServicePointEntity {
  final int id;
  final String code;
  final String name;
  final String carrier;
  final String carrierLogo;
  final String type;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final int distance;
  final String distanceKm;
  final Map<String, List<String>> openingHours;
  final bool isOpen24Hours;
  final bool isActive;
  final bool isOpenTomorrow;
  final bool isOpenUpcomingWeek;
  final String status;

  ServicePointEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.carrier,
    required this.carrierLogo,
    required this.type,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.distanceKm,
    required this.openingHours,
    required this.isOpen24Hours,
    required this.isActive,
    required this.isOpenTomorrow,
    required this.isOpenUpcomingWeek,
    required this.status,
  });

  @override
  String toString() =>
      'ServicePointEntity(id: $id, name: $name, carrier: $carrier, type: $type, distance: $distance, isActive: $isActive)';
}

/// Entity representing grouped service points by carrier
class GroupedByCarrierEntity {
  final String carrier;
  final int count;
  final List<ServicePointEntity> points;

  GroupedByCarrierEntity({
    required this.carrier,
    required this.count,
    required this.points,
  });
}

/// Entity representing service points for a cart item
class CartItemServicePointsEntity {
  final String cartItemId;
  final String postId;
  final ItemDimensionsEntity itemDimensions;
  final List<ServicePointEntity> servicePoints;
  final List<GroupedByCarrierEntity> groupedByCarrier;
  final int totalServicePoints;

  CartItemServicePointsEntity({
    required this.cartItemId,
    required this.postId,
    required this.itemDimensions,
    required this.servicePoints,
    required this.groupedByCarrier,
    required this.totalServicePoints,
  });
}

/// Entity representing the query parameters
class ServicePointQueryEntity {
  final String postalCode;
  final String carrier;
  final int radius;
  final List<String> cartItemIds;

  ServicePointQueryEntity({
    required this.postalCode,
    required this.carrier,
    required this.radius,
    required this.cartItemIds,
  });
}

/// Entity representing the service points response
class ServicePointsResponseEntity {
  final bool success;
  final ServicePointQueryEntity query;
  final int totalServicePoints;
  final Map<String, CartItemServicePointsEntity> results;

  ServicePointsResponseEntity({
    required this.success,
    required this.query,
    required this.totalServicePoints,
    required this.results,
  });
}
