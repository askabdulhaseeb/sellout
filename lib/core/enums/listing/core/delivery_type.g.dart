// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryTypeAdapter extends TypeAdapter<DeliveryType> {
  @override
  final int typeId = 24;

  @override
  DeliveryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryType.paid;
      case 1:
        return DeliveryType.freeDelivery;
      case 2:
        return DeliveryType.collocation;
      default:
        return DeliveryType.paid;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryType obj) {
    switch (obj) {
      case DeliveryType.paid:
        writer.writeByte(0);
        break;
      case DeliveryType.freeDelivery:
        writer.writeByte(1);
        break;
      case DeliveryType.collocation:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
