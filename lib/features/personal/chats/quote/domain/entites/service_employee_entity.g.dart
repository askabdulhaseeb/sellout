// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_employee_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceEmployeeEntityAdapter extends TypeAdapter<ServiceEmployeeEntity> {
  @override
  final int typeId = 78;

  @override
  ServiceEmployeeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceEmployeeEntity(
      serviceId: fields[1] as String,
      quantity: fields[2] as int,
      bookAt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceEmployeeEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.serviceId)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.bookAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceEmployeeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
