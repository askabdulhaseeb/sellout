// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_employee_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessEmployeeEntityAdapter
    extends TypeAdapter<BusinessEmployeeEntity> {
  @override
  final int typeId = 41;

  @override
  BusinessEmployeeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessEmployeeEntity(
      uid: fields[0] as String,
      role: fields[1] as String,
      addBy: fields[2] as String?,
      joinAt: fields[3] as DateTime,
      chatAt: fields[5] as DateTime,
      source: fields[4] as String?,
      status: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessEmployeeEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.addBy)
      ..writeByte(3)
      ..write(obj.joinAt)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.chatAt)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessEmployeeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
