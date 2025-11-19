// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_post_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessagePostDetailEntityAdapter
    extends TypeAdapter<MessagePostDetailEntity> {
  @override
  final int typeId = 87;

  @override
  MessagePostDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessagePostDetailEntity(
      postId: fields[0] as String?,
      title: fields[1] as String?,
      price: fields[2] as num?,
      currency: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessagePostDetailEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagePostDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
