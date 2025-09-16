// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_option_data_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DropdownOptionDataEntityAdapter
    extends TypeAdapter<DropdownOptionDataEntity> {
  @override
  final int typeId = 76;

  @override
  DropdownOptionDataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DropdownOptionDataEntity(
      label: fields[0] as String,
      value: fields[1] as String,
      no: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DropdownOptionDataEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.no);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownOptionDataEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
