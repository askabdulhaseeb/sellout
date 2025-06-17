import '../../domain/entities/login_info_entity.dart';

class DeviceLoginInfoModel extends DeviceLoginInfoEntity {
  DeviceLoginInfoModel(
      {required super.deviceId,
      required super.os,
      required super.appVersion,
      required super.lastLoginTime,
      required super.ip,
      required super.deviceType,
      required super.location,
      required super.platform,
      required super.deviceName});

  factory DeviceLoginInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceLoginInfoModel(
        deviceId: json['device_id'] ?? 'na',
        os: json['os'] ?? 'na',
        appVersion: json['app_version']?.toString() ?? 'na',
        lastLoginTime: DateTime.tryParse(json['last_login_time'] ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        ip: json['ip'] ?? 'na',
        deviceType: json['device_type'] ?? 'na',
        location: json['location'] ?? 'na',
        platform: json['platform'] ?? 'na',
        deviceName: json['device_name'] ?? 'na');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'device_id': deviceId,
      'os': os,
      'app_version': appVersion,
      'last_login_time': lastLoginTime.toIso8601String(),
      'ip': ip,
      'device_type': deviceType,
      'location': location,
      'platform': platform,
      'device_name': deviceName,
    };
  }
}
