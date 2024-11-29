// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_support_info_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSupportInfoEntityAdapter extends TypeAdapter<UserSupportInfoEntity> {
  @override
  final int typeId = 45;

  @override
  UserSupportInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSupportInfoEntity(
      userID: fields[0] as String,
      supportDate: fields[1] as DateTime,
      status: fields[2] as StatusType,
    );
  }

  @override
  void write(BinaryWriter writer, UserSupportInfoEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.supportDate)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSupportInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
