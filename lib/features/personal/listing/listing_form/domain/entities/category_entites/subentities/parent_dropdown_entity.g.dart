// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_dropdown_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentDropdownEntityAdapter extends TypeAdapter<ParentDropdownEntity> {
  @override
  final typeId = 81;

  @override
  ParentDropdownEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParentDropdownEntity(
      category: fields[0] as String,
      options: (fields[1] as List).cast<DropdownOptionEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ParentDropdownEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentDropdownEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
