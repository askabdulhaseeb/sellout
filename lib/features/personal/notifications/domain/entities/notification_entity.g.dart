// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationEntityAdapter extends TypeAdapter<NotificationEntity> {
  @override
  final typeId = 65;

  @override
  NotificationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationEntity(
      notificationId: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      title: fields[3] as String,
      deliverTo: fields[4] as String,
      message: fields[5] as String,
      isViewed: fields[6] as bool,
      metadata: fields[7] as NotificationMetadataEntity,
      notificationFor: fields[8] as String,
      timestamps: fields[9] as DateTime,
      status: fields[10] as StatusType?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.notificationId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.deliverTo)
      ..writeByte(5)
      ..write(obj.message)
      ..writeByte(6)
      ..write(obj.isViewed)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.notificationFor)
      ..writeByte(9)
      ..write(obj.timestamps)
      ..writeByte(10)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
