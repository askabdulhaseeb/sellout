// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemStatusTypeAdapter extends TypeAdapter<CartItemStatusType> {
  @override
  final typeId = 86;

  @override
  CartItemStatusType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CartItemStatusType.cart;
      case 1:
        return CartItemStatusType.saveLater;
      default:
        return CartItemStatusType.cart;
    }
  }

  @override
  void write(BinaryWriter writer, CartItemStatusType obj) {
    switch (obj) {
      case CartItemStatusType.cart:
        writer.writeByte(0);
      case CartItemStatusType.saveLater:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemStatusTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
