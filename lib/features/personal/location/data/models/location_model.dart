import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  factory LocationModel.fromNominationJson(Map<String, dynamic> map) {
    return LocationModel(
      id: map['place_id']?.toString() ?? '',
      title: map['display_name']?.toString().split(',').first ?? '',
      address: map['display_name']?.toString() ?? '',
      url: 'https://maps.google.com/?q=${map['lat']},${map['lon']}',
      latitude: double.tryParse(map['lat']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(map['lon']?.toString() ?? '') ?? 0.0,
    );
  }
  LocationModel({
    required super.address,
    required super.id,
    required super.title,
    required super.url,
    required super.latitude,
    required super.longitude,
  });
  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      id: entity.id,
      title: entity.title,
      url: entity.url,
    );
  }
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
