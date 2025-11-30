// location_name_model.dart
import 'dart:convert';
import '../../../domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';

class NominationLocationModel extends NominationLocationEntity {
  NominationLocationModel({
    required super.placeId,
    required super.lat,
    required super.lon,
    required super.displayName,
    required super.type,
    super.address,
    super.boundingBox,
  });

  factory NominationLocationModel.fromEntity(NominationLocationEntity entity) {
    return NominationLocationModel(
      placeId: entity.placeId,
      lat: entity.lat,
      lon: entity.lon,
      displayName: entity.displayName,
      type: entity.type,
      address: entity.address,
      boundingBox: entity.boundingBox,
    );
  }

  factory NominationLocationModel.fromJson(Map<String, dynamic> map) {
    return NominationLocationModel(
      placeId: map['place_id'].toString(), // convert int → String
      lat: double.tryParse(map['lat'].toString()) ??
          0.0, // parse String → double
      lon: double.tryParse(map['lon'].toString()) ?? 0.0,
      displayName: map['display_name'] as String,
      type: map['type'] as String,
      address: map['address'] != null
          ? NominationAddressModel.fromJson(
              map['address'] as Map<String, dynamic>)
          : null,
      boundingBox: map['boundingbox'] != null
          ? BoundingBoxModel.fromJson(map['boundingbox'] as List<dynamic>)
          : null,
    );
  }

  factory NominationLocationModel.fromRawJson(String str) =>
      NominationLocationModel.fromJson(json.decode(str));
}

class NominationAddressModel extends NominationAddressEntity {
  NominationAddressModel({
    super.city,
    super.county,
    super.state,
    super.country,
    super.countryCode,
  });

  factory NominationAddressModel.fromJson(Map<String, dynamic> map) {
    return NominationAddressModel(
      city: map['city'] as String?,
      county: map['county'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      countryCode: map['country_code'] as String?,
    );
  }
}

class BoundingBoxModel extends BoundingBoxEntity {
  BoundingBoxModel({
    required super.north,
    required super.south,
    required super.east,
    required super.west,
  });

  /// Nominatim sends boundingbox as [south, north, west, east]
  factory BoundingBoxModel.fromJson(List<dynamic> list) {
    return BoundingBoxModel(
      south: list[0] as String,
      north: list[1] as String,
      west: list[2] as String,
      east: list[3] as String,
    );
  }
}
