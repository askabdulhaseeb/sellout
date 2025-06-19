import 'package:hive_flutter/hive_flutter.dart';

import '../../../marketplace/domain/entities/location_name_entity.dart';

part 'location_entity.g.dart';

@HiveType(typeId: 17)
class LocationEntity {
  LocationEntity({
    required this.address,
    required this.id,
    required this.title,
    required this.url,
    required this.latitude,
    required this.longitude,
  });

  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? url;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? address;
  @HiveField(4)
  final double? latitude;
  @HiveField(5)
  final double? longitude;

  static LocationEntity fromLocationName({
    required LocationNameEntity entity,
    required double latitude,
    required double longitude,
  }) {
    return LocationEntity(
      id: entity.placeId,
      title: entity.structuredFormatting.mainText,
      address: entity.description,
      url: 'www.test.com', // Replace with actual URL logic if available
      latitude: latitude,
      longitude: longitude,
    );
  }
}
