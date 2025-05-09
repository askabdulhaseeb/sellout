// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferDetailEntityAdapter extends TypeAdapter<OfferDetailEntity> {
  @override
  final int typeId = 19;

  @override
  OfferDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfferDetailEntity(
      postTitle: fields[0] as String,
      size: fields[1] as String,
      color: fields[2] as String,
      post: fields[3] as PostEntity,
      price: fields[4] as int,
      minOfferAmount: fields[5] as int,
      currency: fields[7] as String,
      offerId: fields[8] as String,
      offerPrice: fields[9] as int,
      quantity: fields[10] as int,
      offerStatus: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfferDetailEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.postTitle)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.post)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.minOfferAmount)
      ..writeByte(6)
      ..write(obj.offerStatus)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.offerId)
      ..writeByte(9)
      ..write(obj.offerPrice)
      ..writeByte(10)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
