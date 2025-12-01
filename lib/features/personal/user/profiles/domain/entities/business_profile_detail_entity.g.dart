// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileBusinessDetailEntityAdapter
    extends TypeAdapter<ProfileBusinessDetailEntity> {
  @override
  final typeId = 48;

  @override
  ProfileBusinessDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileBusinessDetailEntity(
      businessID: fields[0] as String,
      roleSTR: fields[1] as String,
      statusSTR: fields[2] as String,
      addedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileBusinessDetailEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.businessID)
      ..writeByte(1)
      ..write(obj.roleSTR)
      ..writeByte(2)
      ..write(obj.statusSTR)
      ..writeByte(3)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileBusinessDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
