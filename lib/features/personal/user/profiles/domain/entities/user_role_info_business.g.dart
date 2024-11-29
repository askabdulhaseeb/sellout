// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_info_business.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRoleInfoInBusinessEntityAdapter
    extends TypeAdapter<UserRoleInfoInBusinessEntity> {
  @override
  final int typeId = 44;

  @override
  UserRoleInfoInBusinessEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRoleInfoInBusinessEntity(
      businessID: fields[0] as String,
      role: fields[1] as String,
      addedAt: fields[2] as DateTime,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserRoleInfoInBusinessEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.businessID)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.addedAt)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleInfoInBusinessEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
