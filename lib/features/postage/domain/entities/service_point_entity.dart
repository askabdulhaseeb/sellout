/// Entity representing item dimensions
class ItemDimensionsEntity {

  ItemDimensionsEntity({
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });
  final double length;
  final double width;
  final double height;
  final double weight;
}

/// Entity representing a service point for pickup
class ServicePointEntity {

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

  @override
  String toString() =>
      'ServicePointEntity(id: $id, name: $name, carrier: $carrier, type: $type, distance: $distance, isActive: $isActive)';
}

/// Entity representing grouped service points by carrier
class GroupedByCarrierEntity {

  GroupedByCarrierEntity({
    required this.carrier,
    required this.count,
    required this.points,
  });
  final String carrier;
  final int count;
  final List<ServicePointEntity> points;
}

/// Entity representing service points for a cart item
class CartItemServicePointsEntity {

  CartItemServicePointsEntity({
    required this.cartItemId,
    required this.postId,
    required this.itemDimensions,
    required this.totalServicePoints,
    required this.servicePoints,
    required this.groupedByCarrier,
  });
  final String cartItemId;
  final String postId;
  final ItemDimensionsEntity itemDimensions;
  final int totalServicePoints;
  final List<ServicePointEntity> servicePoints;
  final List<GroupedByCarrierEntity> groupedByCarrier;
}

/// Entity representing the query parameters
class ServicePointQueryEntity {

  ServicePointQueryEntity({
    required this.postalCode,
    required this.carrier,
    required this.radius,
    required this.cartItemIds,
  });
  final String postalCode;
  final String carrier;
  final int radius;
  final List<String> cartItemIds;
}

/// Response entity containing service points data
class ServicePointsResponseEntity {

  ServicePointsResponseEntity({
    required this.success,
    required this.query,
    required this.totalServicePoints,
    required this.results,
  });
  final bool success;
  final ServicePointQueryEntity query;
  final int totalServicePoints;
  final Map<String, CartItemServicePointsEntity> results;
}
