// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_metadata_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationMetadataEntityAdapter
    extends TypeAdapter<NotificationMetadataEntity> {
  @override
  final int typeId = 66;

  @override
  NotificationMetadataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationMetadataEntity(
      orderId: fields[0] as String,
      trackId: fields[1] as String,
      postId: fields[2] as String,
      paymentDetail: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationMetadataEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.trackId)
      ..writeByte(2)
      ..write(obj.postId)
      ..writeByte(3)
      ..write(obj.paymentDetail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationMetadataEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
