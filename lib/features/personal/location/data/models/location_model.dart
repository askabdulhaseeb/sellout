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
        id: json['location_id'] ?? json['id'] ?? '',
        title: json['title'] ?? '',
        url: json['location_url'] ?? json['url'] ?? '',
        latitude: (json['latitude'] ?? 0).toDouble(),
        longitude: (json['longitude'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address.toString(),
        'location_id': id,
        'title': title,
        'location_url': url,
        'latitude': latitude,
        'longitude': longitude,
      };
  Map<String, dynamic> toJsonidurlkeys() => <String, dynamic>{
        'address': address.toString(),
        'id': id,
        'title': title,
        'url': url,
        'latitude': latitude,
        'longitude': longitude,
      };
}
