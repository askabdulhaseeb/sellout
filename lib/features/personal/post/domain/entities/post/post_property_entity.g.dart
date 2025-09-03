// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_property_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostPropertyEntityAdapter extends TypeAdapter<PostPropertyEntity> {
  @override
  final int typeId = 71;

  @override
  PostPropertyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostPropertyEntity(
      bedroom: fields[0] as int?,
      bathroom: fields[1] as int?,
      energyRating: fields[2] as String?,
      propertyType: fields[3] as String?,
      propertyCategory: fields[4] as String?,
      garden: fields[5] as bool?,
      parking: fields[6] as bool?,
      tenureType: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostPropertyEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bedroom)
      ..writeByte(1)
      ..write(obj.bathroom)
      ..writeByte(2)
      ..write(obj.energyRating)
      ..writeByte(3)
      ..write(obj.propertyType)
      ..writeByte(4)
      ..write(obj.propertyCategory)
      ..writeByte(5)
      ..write(obj.garden)
      ..writeByte(6)
      ..write(obj.parking)
      ..writeByte(7)
      ..write(obj.tenureType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostPropertyEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
