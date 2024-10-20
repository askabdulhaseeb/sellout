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
      messages: (fields[0] as List).cast<MessageEntity>(),
      lastEvaluatedKey: fields[1] as MessageLastEvaluatedKeyEntity,
    );
  }

  @override
  void write(BinaryWriter writer, GettedMessageEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.messages)
      ..writeByte(1)
      ..write(obj.lastEvaluatedKey);
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
