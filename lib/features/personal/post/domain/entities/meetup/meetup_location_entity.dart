import 'package:hive/hive.dart';

part 'meetup_location_entity.g.dart';

@HiveType(typeId: 17)
class MeetUpLocationEntity {
  MeetUpLocationEntity({
    required this.address,
    required this.id,
    required this.title,
    required this.url,
    required this.latitude,
    required this.longitude,
  });

  @HiveField(0)
  final String address;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final double latitude;
  @HiveField(5)
  final double longitude;
}
