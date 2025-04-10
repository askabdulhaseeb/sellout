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
      quantity: fields[0] as int,
      discount: fields[1] as num,
    );
  }

  @override
  void write(BinaryWriter writer, DiscountEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.discount);
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
