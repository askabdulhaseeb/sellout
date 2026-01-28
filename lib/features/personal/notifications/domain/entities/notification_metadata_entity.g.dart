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
      status: fields[6] as StatusType?,
      createdAt: fields[7] as DateTime?,
      paymentDetail: fields[8] as OrderPaymentDetailEntity?,
      quantity: (fields[9] as num?)?.toInt(),
      totalAmount: (fields[10] as num?)?.toDouble(),
      currency: fields[11] as String?,
      itemTitle: fields[12] as String?,
      event: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationMetadataEntity obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.paymentDetail)
      ..writeByte(9)
      ..write(obj.quantity)
      ..writeByte(10)
      ..write(obj.totalAmount)
      ..writeByte(11)
      ..write(obj.currency)
      ..writeByte(12)
      ..write(obj.itemTitle)
      ..writeByte(13)
      ..write(obj.event);
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
