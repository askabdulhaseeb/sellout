// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_listings_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DropdownOptionEntityAdapter extends TypeAdapter<DropdownOptionEntity> {
  @override
  final int typeId = 58;

  @override
  DropdownOptionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DropdownOptionEntity(
      label: fields[0] as String,
      value: fields[1] as String,
      children: (fields[2] as List).cast<DropdownOptionEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, DropdownOptionEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownOptionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DropdownCategoryEntityAdapter
    extends TypeAdapter<DropdownCategoryEntity> {
  @override
  final int typeId = 59;

  @override
  DropdownCategoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DropdownCategoryEntity(
      key: fields[0] as String,
      options: (fields[1] as List).cast<DropdownOptionEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, DropdownCategoryEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownCategoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
