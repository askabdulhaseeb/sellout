// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscountEntityAdapter extends TypeAdapter<DiscountEntity> {
  @override
  final int typeId = 21;

  @override
  DiscountEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscountEntity(
      discount3Item: fields[0] as int,
      discount5Item: fields[1] as int,
      discount2Item: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DiscountEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.discount3Item)
      ..writeByte(1)
      ..write(obj.discount5Item)
      ..writeByte(2)
      ..write(obj.discount2Item);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
