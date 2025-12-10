// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_into_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupInfoEntityAdapter extends TypeAdapter<GroupInfoEntity> {
  @override
  final typeId = 29;

  @override
  GroupInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupInfoEntity(
      description: fields[0] as String,
      title: fields[1] as String,
      createdBy: fields[2] as String,
      invitations: (fields[3] as List).cast<InvitationEntity>(),
      imageUrl: (fields[4] as List).cast<AttachmentEntity>(),
      participants: (fields[5] as List).cast<ChatParticipantEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, GroupInfoEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.invitations)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.participants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
