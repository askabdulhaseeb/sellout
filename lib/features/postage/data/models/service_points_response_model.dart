import '../../domain/entities/service_point_entity.dart';

/// Model for item dimensions
class ItemDimensionsModel extends ItemDimensionsEntity {
  ItemDimensionsModel({
    required super.length,
    required super.width,
    required super.height,
    required super.weight,
  });

  factory ItemDimensionsModel.fromJson(Map<String, dynamic> json) {
    return ItemDimensionsModel(
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'length': length,
    'width': width,
    'height': height,
    'weight': weight,
  };
}

/// Model for a service point from API response
class ServicePointModel extends ServicePointEntity {
  ServicePointModel({
    required super.id,
    required super.code,
    required super.name,
    required super.carrier,
    required super.carrierLogo,
    required super.type,
    required super.address,
    required super.city,
    required super.postalCode,
    required super.country,
    required super.latitude,
    required super.longitude,
    required super.distance,
    required super.distanceKm,
    required super.openingHours,
    required super.isOpen24Hours,
    required super.isActive,
    required super.isOpenTomorrow,
    required super.isOpenUpcomingWeek,
    required super.status,
  });

  factory ServicePointModel.fromEntity(ServicePointEntity entity) {
    return ServicePointModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      carrier: entity.carrier,
      carrierLogo: entity.carrierLogo,
      type: entity.type,
      address: entity.address,
      city: entity.city,
      postalCode: entity.postalCode,
      country: entity.country,
      latitude: entity.latitude,
      longitude: entity.longitude,
      distance: entity.distance,
      distanceKm: entity.distanceKm,
      openingHours: entity.openingHours,
      isOpen24Hours: entity.isOpen24Hours,
      isActive: entity.isActive,
      isOpenTomorrow: entity.isOpenTomorrow,
      isOpenUpcomingWeek: entity.isOpenUpcomingWeek,
      status: entity.status,
    );
  }

  factory ServicePointModel.fromJson(Map<String, dynamic> json) {
    // Parse opening hours
    final Map<String, List<String>> openingHours = <String, List<String>>{};
    final Map<String, dynamic>? hoursJson =
        json['openingHours'] as Map<String, dynamic>?;
    if (hoursJson != null) {
      hoursJson.forEach((String key, dynamic value) {
        if (value is List) {
          openingHours[key] = value.map((dynamic e) => e.toString()).toList();
        }
      });
    }

    return ServicePointModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      carrier: json['carrier'] as String? ?? '',
      carrierLogo: json['carrierLogo'] as String? ?? '',
      type: json['type'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distance: json['distance'] as int? ?? 0,
      distanceKm: json['distanceKm'] as String? ?? '',
      openingHours: openingHours,
      isOpen24Hours: json['isOpen24Hours'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      isOpenTomorrow: json['isOpenTomorrow'] as bool? ?? false,
      isOpenUpcomingWeek: json['isOpenUpcomingWeek'] as bool? ?? false,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'code': code,
    'name': name,
    'carrier': carrier,
    'carrierLogo': carrierLogo,
    'type': type,
    'address': address,
    'city': city,
    'postalCode': postalCode,
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
    'distance': distance,
    'distanceKm': distanceKm,
    'openingHours': openingHours,
    'isOpen24Hours': isOpen24Hours,
    'isActive': isActive,
    'isOpenTomorrow': isOpenTomorrow,
    'isOpenUpcomingWeek': isOpenUpcomingWeek,
    'status': status,
  };
}

/// Model for grouped service points by carrier
class GroupedByCarrierModel extends GroupedByCarrierEntity {
  GroupedByCarrierModel({
    required super.carrier,
    required super.count,
    required super.points,
  });

  factory GroupedByCarrierModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> pointsJson =
        json['points'] as List<dynamic>? ?? <dynamic>[];
    final List<ServicePointEntity> points = pointsJson
        .map(
          (dynamic item) =>
              ServicePointModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return GroupedByCarrierModel(
      carrier: json['carrier'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      points: points,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'carrier': carrier,
    'count': count,
    'points': points
        .map((ServicePointEntity p) => (p as ServicePointModel).toJson())
        .toList(),
  };
}

/// Model for service points for a cart item
class CartItemServicePointsModel extends CartItemServicePointsEntity {
  CartItemServicePointsModel({
    required super.cartItemId,
    required super.postId,
    required super.itemDimensions,
    required super.totalServicePoints,
    required super.servicePoints,
    required super.groupedByCarrier,
  });

  factory CartItemServicePointsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> servicePointsJson =
        json['service_points'] as List<dynamic>? ?? <dynamic>[];
    final List<ServicePointEntity> servicePoints = servicePointsJson
        .map(
          (dynamic item) =>
              ServicePointModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final List<dynamic> groupedJson =
        json['grouped_by_carrier'] as List<dynamic>? ?? <dynamic>[];
    final List<GroupedByCarrierEntity> grouped = groupedJson
        .map(
          (dynamic item) =>
              GroupedByCarrierModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return CartItemServicePointsModel(
      cartItemId: json['cart_item_id'] as String? ?? '',
      postId: json['post_id'] as String? ?? '',
      itemDimensions: ItemDimensionsModel.fromJson(
        json['item_dimensions'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      totalServicePoints: json['total_service_points'] as int? ?? 0,
      servicePoints: servicePoints,
      groupedByCarrier: grouped,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cart_item_id': cartItemId,
    'post_id': postId,
    'item_dimensions': (itemDimensions as ItemDimensionsModel).toJson(),
    'total_service_points': totalServicePoints,
    'service_points': servicePoints
        .map((ServicePointEntity p) => (p as ServicePointModel).toJson())
        .toList(),
    'grouped_by_carrier': groupedByCarrier
        .map(
          (GroupedByCarrierEntity g) => (g as GroupedByCarrierModel).toJson(),
        )
        .toList(),
  };
}

/// Model for the query parameters
class ServicePointQueryModel extends ServicePointQueryEntity {
  ServicePointQueryModel({
    required super.postalCode,
    required super.carrier,
    required super.radius,
    required super.cartItemIds,
  });

  factory ServicePointQueryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> idsJson =
        json['cart_item_ids'] as List<dynamic>? ?? <dynamic>[];
    final List<String> ids = idsJson.map((dynamic e) => e.toString()).toList();

    return ServicePointQueryModel(
      postalCode: json['postal_code'] as String? ?? '',
      carrier: json['carrier'] as String? ?? '',
      radius: json['radius'] as int? ?? 0,
      cartItemIds: ids,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'postal_code': postalCode,
    'carrier': carrier,
    'radius': radius,
    'cart_item_ids': cartItemIds,
  };
}

/// Model for service points response from API
class ServicePointsResponseModel extends ServicePointsResponseEntity {
  ServicePointsResponseModel({
    required super.success,
    required super.query,
    required super.totalServicePoints,
    required super.results,
  });

  factory ServicePointsResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> resultsJson =
        json['results'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, CartItemServicePointsEntity> results =
        <String, CartItemServicePointsEntity>{};

    resultsJson.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        results[key] = CartItemServicePointsModel.fromJson(value);
      }
    });

    return ServicePointsResponseModel(
      success: json['success'] as bool? ?? false,
      query: ServicePointQueryModel.fromJson(
        json['query'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      totalServicePoints: json['total_service_points'] as int? ?? 0,
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultsJson = <String, dynamic>{};
    results.forEach((String key, CartItemServicePointsEntity value) {
      resultsJson[key] = (value as CartItemServicePointsModel).toJson();
    });

    return <String, dynamic>{
      'success': success,
      'query': (query as ServicePointQueryModel).toJson(),
      'total_service_points': totalServicePoints,
      'results': resultsJson,
    };
  }
}
