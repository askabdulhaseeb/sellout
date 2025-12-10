// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemEntityAdapter extends TypeAdapter<CartItemEntity> {
  @override
  final typeId = 38;

  @override
  CartItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemEntity(
      quantity: (fields[0] as num).toInt(),
      postID: fields[1] as String,
      listID: fields[2] as String,
      color: fields[3] as String?,
      size: fields[4] as String?,
      cartItemID: fields[5] as String,
      status: fields[6] as CartItemStatusType,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.postID)
      ..writeByte(2)
      ..write(obj.listID)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.cartItemID)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
