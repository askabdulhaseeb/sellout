import '../../domain/entities/login_info_entity.dart';

class DeviceLoginInfoModel extends DeviceLoginInfoEntity {
  DeviceLoginInfoModel({
    required super.deviceId,
    required super.os,
    required super.appVersion,
    required super.lastLoginTime,
    required super.ip,
    required super.deviceType,
    required super.location,
    required super.platform,
  });

  factory DeviceLoginInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceLoginInfoModel(
      deviceId: json['device_id'] ?? 'unknown-device',
      os: json['os'] ?? 'unknown',
      appVersion: json['app_version'] ?? 'unknown',
      lastLoginTime: DateTime.parse(json['last_login_time']),
      ip: json['ip'] ?? 'unknown',
      deviceType: json['device_type'] ?? 'unknown',
      location: json['location'] ?? 'unknown',
      platform: json['platform'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'os': os,
      'app_version': appVersion,
      'last_login_time': lastLoginTime.toIso8601String(),
      'ip': ip,
      'device_type': deviceType,
      'location': location,
      'platform': platform,
    };
  }
}
