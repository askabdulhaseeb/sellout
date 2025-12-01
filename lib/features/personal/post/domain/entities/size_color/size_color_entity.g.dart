// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_color_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SizeColorEntityAdapter extends TypeAdapter<SizeColorEntity> {
  @override
  final typeId = 22;

  @override
  SizeColorEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SizeColorEntity(
      value: fields[0] as String,
      colors: (fields[1] as List).cast<ColorEntity>(),
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SizeColorEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.colors)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeColorEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
