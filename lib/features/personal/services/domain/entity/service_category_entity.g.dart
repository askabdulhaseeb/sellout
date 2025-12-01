// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceCategoryEntityAdapter extends TypeAdapter<ServiceCategoryEntity> {
  @override
  final typeId = 76;

  @override
  ServiceCategoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceCategoryEntity(
      label: fields[0] as String,
      value: fields[1] as String,
      imgURL: fields[2] as String,
      category: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
      serviceTypes: (fields[5] as List).cast<ServiceTypeEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ServiceCategoryEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.imgURL)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.serviceTypes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
