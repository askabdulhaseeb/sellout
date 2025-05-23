// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_info_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceLoginInfoEntityAdapter extends TypeAdapter<DeviceLoginInfoEntity> {
  @override
  final int typeId = 54;

  @override
  DeviceLoginInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceLoginInfoEntity(
      deviceId: fields[0] as String,
      os: fields[1] as String,
      appVersion: fields[2] as String,
      lastLoginTime: fields[3] as DateTime,
      ip: fields[4] as String,
      deviceType: fields[5] as String,
      location: fields[6] as String,
      platform: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceLoginInfoEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.os)
      ..writeByte(2)
      ..write(obj.appVersion)
      ..writeByte(3)
      ..write(obj.lastLoginTime)
      ..writeByte(4)
      ..write(obj.ip)
      ..writeByte(5)
      ..write(obj.deviceType)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.platform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceLoginInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
