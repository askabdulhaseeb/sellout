// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShippingDetailEntityAdapter extends TypeAdapter<ShippingDetailEntity> {
  @override
  final typeId = 89;

  @override
  ShippingDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShippingDetailEntity(
      postage: (fields[0] as List).cast<PostageEntity>(),
      fastDelivery: fields[1] as FastDeliveryEntity?,
      fromAddress: fields[2] as AddressEntity?,
      toAddress: fields[3] as AddressEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, ShippingDetailEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.postage)
      ..writeByte(1)
      ..write(obj.fastDelivery)
      ..writeByte(2)
      ..write(obj.fromAddress)
      ..writeByte(3)
      ..write(obj.toAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
