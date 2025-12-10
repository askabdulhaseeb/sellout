// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant_role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatParticipantRoleTypeAdapter
    extends TypeAdapter<ChatParticipantRoleType> {
  @override
  final typeId = 12;

  @override
  ChatParticipantRoleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatParticipantRoleType.admin;
      case 1:
        return ChatParticipantRoleType.member;
      default:
        return ChatParticipantRoleType.admin;
    }
  }

  @override
  void write(BinaryWriter writer, ChatParticipantRoleType obj) {
    switch (obj) {
      case ChatParticipantRoleType.admin:
        writer.writeByte(0);
      case ChatParticipantRoleType.member:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatParticipantRoleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
