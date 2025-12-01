// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceTypeEntityAdapter extends TypeAdapter<ServiceTypeEntity> {
  @override
  final typeId = 77;

  @override
  ServiceTypeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceTypeEntity(
      value: fields[0] as String,
      label: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceTypeEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceTypeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
