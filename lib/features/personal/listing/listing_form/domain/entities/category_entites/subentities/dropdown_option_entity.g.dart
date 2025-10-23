// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_option_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DropdownOptionEntityAdapter extends TypeAdapter<DropdownOptionEntity> {
  @override
  final int typeId = 79;

  @override
  DropdownOptionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DropdownOptionEntity(
      label: fields[0] as String,
      value: fields[1] as DropdownOptionDataEntity,
    );
  }

  @override
  void write(BinaryWriter writer, DropdownOptionEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value);
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
