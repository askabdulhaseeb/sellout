// location_name_entity.dart
class NominationLocationEntity {
  NominationLocationEntity({
    required this.placeId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.type,
    this.address,
    this.boundingBox,
  });

  final String placeId;
  final double lat;
  final double lon;
  final String displayName;
  final String type;
  final AddressEntity? address;
  final BoundingBoxEntity? boundingBox;
}

class AddressEntity {
  AddressEntity({
    this.city,
    this.county,
    this.state,
    this.country,
    this.countryCode,
  });

  final String? city;
  final String? county;
  final String? state;
  final String? country;
  final String? countryCode;
}

class BoundingBoxEntity {
  BoundingBoxEntity({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  final String north;
  final String south;
  final String east;
  final String west;
}
