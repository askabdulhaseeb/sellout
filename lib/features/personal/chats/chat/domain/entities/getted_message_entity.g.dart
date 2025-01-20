// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getted_message_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GettedMessageEntityAdapter extends TypeAdapter<GettedMessageEntity> {
  @override
  final int typeId = 33;

  @override
  GettedMessageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GettedMessageEntity(
      chatID: fields[2] as String,
      messages: (fields[0] as List).cast<MessageEntity>(),
      lastEvaluatedKey: fields[1] as MessageLastEvaluatedKeyEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, GettedMessageEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.messages)
      ..writeByte(1)
      ..write(obj.lastEvaluatedKey)
      ..writeByte(2)
      ..write(obj.chatID)
      ..writeByte(99)
      ..write(obj.inHiveAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GettedMessageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
