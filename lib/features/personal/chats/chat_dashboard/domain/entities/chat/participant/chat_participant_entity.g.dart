// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatParticipantEntityAdapter extends TypeAdapter<ChatParticipantEntity> {
  @override
  final typeId = 11;

  @override
  ChatParticipantEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatParticipantEntity(
      uid: fields[0] as String,
      joinAt: fields[1] as DateTime,
      role: fields[2] as ChatParticipantRoleType,
      source: fields[4] as String,
      chatAt: fields[5] as DateTime,
      addBy: fields[3] as String?,
      addedBy: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatParticipantEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.joinAt)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.addBy)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.chatAt)
      ..writeByte(6)
      ..write(obj.addedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatParticipantEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
