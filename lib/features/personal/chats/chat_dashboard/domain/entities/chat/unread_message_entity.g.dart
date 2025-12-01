// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_message_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnreadMessageEntityAdapter extends TypeAdapter<UnreadMessageEntity> {
  @override
  final typeId = 55;

  @override
  UnreadMessageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnreadMessageEntity(
      chatId: fields[0] as String,
      count: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UnreadMessageEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnreadMessageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
