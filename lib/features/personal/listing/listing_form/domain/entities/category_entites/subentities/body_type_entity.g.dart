// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_type_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BodyTypeEntityAdapter extends TypeAdapter<BodyTypeEntity> {
  @override
  final int typeId = 77;

  @override
  BodyTypeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyTypeEntity(
      category: fields[0] as String,
      options: (fields[1] as List).cast<DropdownOptionEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, BodyTypeEntity obj) {
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
      other is BodyTypeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
