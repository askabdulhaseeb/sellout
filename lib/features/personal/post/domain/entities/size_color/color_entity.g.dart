// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorEntityAdapter extends TypeAdapter<ColorEntity> {
  @override
  final int typeId = 23;

  @override
  ColorEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorEntity(
      code: fields[0] as String,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ColorEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
