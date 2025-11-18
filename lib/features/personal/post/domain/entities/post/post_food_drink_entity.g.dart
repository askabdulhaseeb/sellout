// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_food_drink_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostFoodDrinkEntityAdapter extends TypeAdapter<PostFoodDrinkEntity> {
  @override
  final int typeId = 72;

  @override
  PostFoodDrinkEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostFoodDrinkEntity(
      type: fields[0] as String,
      address: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostFoodDrinkEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostFoodDrinkEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
