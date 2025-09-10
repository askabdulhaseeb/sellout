// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceCategoryENtityAdapter extends TypeAdapter<ServiceCategoryENtity> {
  @override
  final int typeId = 72;

  @override
  ServiceCategoryENtity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceCategoryENtity(
      label: fields[0] as String,
      value: fields[1] as String,
      category: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      serviceTypes: (fields[4] as List).cast<ServiceTypeEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ServiceCategoryENtity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.serviceTypes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategoryENtityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
