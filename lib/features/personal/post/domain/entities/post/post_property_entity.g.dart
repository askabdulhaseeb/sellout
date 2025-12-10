// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_property_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostPropertyEntityAdapter extends TypeAdapter<PostPropertyEntity> {
  @override
  final typeId = 71;

  @override
  PostPropertyEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostPropertyEntity(
      bedroom: (fields[0] as num?)?.toInt(),
      bathroom: (fields[1] as num?)?.toInt(),
      energyRating: fields[2] as String?,
      propertyType: fields[3] as String?,
      propertyCategory: fields[4] as String?,
      garden: fields[5] as bool?,
      parking: fields[6] as bool?,
      tenureType: fields[7] as String?,
      address: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostPropertyEntity obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.tenureType)
      ..writeByte(8)
      ..write(obj.address);
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
