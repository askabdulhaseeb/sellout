// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_metadata_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationMetadataEntityAdapter
    extends TypeAdapter<NotificationMetadataEntity> {
  @override
  final typeId = 66;

  @override
  NotificationMetadataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationMetadataEntity(
      postId: fields[0] as String?,
      orderId: fields[1] as String?,
      chatId: fields[2] as String?,
      trackId: fields[3] as String?,
      senderId: fields[4] as String?,
      messageId: fields[5] as String?,
      recipients: (fields[6] as List?)?.cast<String>(),
      paymentDetail: (fields[7] as Map?)?.cast<String, dynamic>(),
      postageDetail: (fields[8] as Map?)?.cast<String, dynamic>(),
      status: fields[9] as StatusType?,
      createdAt: fields[10] as DateTime?,
      rawData: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationMetadataEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.chatId)
      ..writeByte(3)
      ..write(obj.trackId)
      ..writeByte(4)
      ..write(obj.senderId)
      ..writeByte(5)
      ..write(obj.messageId)
      ..writeByte(6)
      ..write(obj.recipients)
      ..writeByte(7)
      ..write(obj.paymentDetail)
      ..writeByte(8)
      ..write(obj.postageDetail)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.rawData);
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
