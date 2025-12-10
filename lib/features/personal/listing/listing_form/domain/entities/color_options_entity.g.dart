// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_options_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorOptionEntityAdapter extends TypeAdapter<ColorOptionEntity> {
  @override
  final typeId = 53;

  @override
  ColorOptionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorOptionEntity(
      label: fields[0] as String,
      value: fields[1] as String,
      shade: fields[2] as String,
      tag: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ColorOptionEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.shade)
      ..writeByte(3)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorOptionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
