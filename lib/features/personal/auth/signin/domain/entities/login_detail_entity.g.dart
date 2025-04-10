// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDetailEntityAdapter extends TypeAdapter<LoginDetailEntity> {
  @override
  final int typeId = 52;

  @override
  LoginDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginDetailEntity(
      type: fields[0] as String,
      role: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginDetailEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
