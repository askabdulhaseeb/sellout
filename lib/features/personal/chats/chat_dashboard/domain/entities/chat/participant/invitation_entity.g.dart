// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvitationEntityAdapter extends TypeAdapter<InvitationEntity> {
  @override
  final typeId = 30;

  @override
  InvitationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvitationEntity(
      uid: fields[0] as String,
      addedBy: fields[1] as String,
      invitedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InvitationEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.addedBy)
      ..writeByte(2)
      ..write(obj.invitedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvitationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
