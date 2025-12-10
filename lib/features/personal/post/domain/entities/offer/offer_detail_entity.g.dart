// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferDetailEntityAdapter extends TypeAdapter<OfferDetailEntity> {
  @override
  final typeId = 19;

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
      price: (fields[4] as num).toInt(),
      minOfferAmount: (fields[5] as num).toInt(),
      currency: fields[7] as String,
      offerId: fields[8] as String,
      offerPrice: (fields[9] as num).toInt(),
      offerStatus: fields[6] as StatusType?,
      quantity: (fields[10] as num).toInt(),
      buyerId: fields[11] as String,
      sellerId: fields[12] as String,
      postId: fields[13] as String,
      counterBy: fields[14] as CounterOfferEnum?,
      counterAmount: (fields[15] as num?)?.toInt(),
      counterCurrency: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfferDetailEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.postTitle)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.color)
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
      ..write(obj.quantity)
      ..writeByte(11)
      ..write(obj.buyerId)
      ..writeByte(12)
      ..write(obj.sellerId)
      ..writeByte(13)
      ..write(obj.postId)
      ..writeByte(14)
      ..write(obj.counterBy)
      ..writeByte(15)
      ..write(obj.counterAmount)
      ..writeByte(16)
      ..write(obj.counterCurrency);
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
