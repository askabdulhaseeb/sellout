// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_last_evaluated_key_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageLastEvaluatedKeyEntityAdapter
    extends TypeAdapter<MessageLastEvaluatedKeyEntity> {
  @override
  final typeId = 34;

  @override
  MessageLastEvaluatedKeyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageLastEvaluatedKeyEntity(
      chatID: fields[0] as String,
      paginationKey: fields[1] as String?,
      createdAt: fields[2] == null ? 'null' : fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageLastEvaluatedKeyEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.chatID)
      ..writeByte(1)
      ..write(obj.paginationKey)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageLastEvaluatedKeyEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
