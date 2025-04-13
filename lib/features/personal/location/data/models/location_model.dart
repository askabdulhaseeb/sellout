import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.address,
    required super.id,
    required super.title,
    required super.url,
    required super.latitude,
    required super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        address: json['address'] ?? '',
        id: json['location_id'] ?? '',
        title: json['title'] ?? '',
        url: json['location_url'] ?? '',
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'location_id': id,
        'title': title,
        'location_url': url,
        'latitude': latitude,
        'longitude': longitude,
      };
  Map<String, dynamic> toJsonidurlkeys() => <String, dynamic>{
        'address': address,
        'id': id,
        'title': title,
        'url': url,
        'latitude': latitude,
        'longitude': longitude,
      };
}
