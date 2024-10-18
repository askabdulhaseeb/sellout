import '../../../domain/entities/meetup/meetup_location_entity.dart';

class MeetUpLocationModel extends MeetUpLocationEntity {
  MeetUpLocationModel({
    required super.address,
    required super.id,
    required super.title,
    required super.url,
    required super.latitude,
    required super.longitude,
  });

  factory MeetUpLocationModel.fromJson(Map<String, dynamic> json) =>
      MeetUpLocationModel(
        address: json['address'],
        id: json['id'],
        title: json['title'],
        url: json['url'],
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'id': id,
        'title': title,
        'url': url,
        'latitude': latitude,
        'longitude': longitude,
      };
}
