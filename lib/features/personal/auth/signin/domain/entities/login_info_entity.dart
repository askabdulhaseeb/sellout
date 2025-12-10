import 'package:hive_ce/hive.dart';
part 'login_info_entity.g.dart';

@HiveType(typeId: 54)
class DeviceLoginInfoEntity {
  DeviceLoginInfoEntity({
    required this.deviceId,
    required this.os,
    required this.appVersion,
    required this.lastLoginTime,
    required this.ip,
    required this.deviceType,
    required this.location,
    required this.platform,
    required this.deviceName,
  });

  @HiveField(0)
  final String deviceId;

  @HiveField(1)
  final String os;

  @HiveField(2)
  final String appVersion;

  @HiveField(3)
  final DateTime lastLoginTime;

  @HiveField(4)
  final String ip;

  @HiveField(5)
  final String deviceType;

  @HiveField(6)
  final String location;

  @HiveField(7)
  final String platform;

  @HiveField(8)
  final String deviceName;
}
