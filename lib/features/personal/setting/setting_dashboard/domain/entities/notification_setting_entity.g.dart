// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsEntityAdapter
    extends TypeAdapter<NotificationSettingsEntity> {
  @override
  final typeId = 57;

  @override
  NotificationSettingsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettingsEntity(
      pushNotification: fields[0] as bool?,
      emailNotification: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettingsEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pushNotification)
      ..writeByte(1)
      ..write(obj.emailNotification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
