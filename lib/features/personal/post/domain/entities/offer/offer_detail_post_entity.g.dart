// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_detail_post_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferDetailPostEntityAdapter extends TypeAdapter<OfferDetailPostEntity> {
  @override
  final int typeId = 20;

  @override
  OfferDetailPostEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfferDetailPostEntity(
      quantity: fields[0] as int,
      address: fields[1] as String,
      isActive: fields[2] as bool,
      listId: fields[3] as String,
      currentLongitude: fields[4] as double,
      createdAt: fields[5] as DateTime,
      discount: fields[6] as DiscountEntity,
      description: fields[7] as String,
      fileUrls: (fields[8] as List).cast<AttachmentEntity>(),
      title: fields[9] as String,
      type: fields[10] as String,
      createdBy: fields[11] as String,
      acceptOffers: fields[12] as String,
      sizeColors: (fields[13] as List).cast<SizeColorEntity>(),
      currentLatitude: fields[14] as double,
      postId: fields[15] as String,
      deliveryType: fields[16] as DeliveryType,
      price: fields[17] as double,
      minOfferAmount: fields[18] as double,
      condition: fields[19] as ConditionType,
      sizeChartUrl: fields[20] as String,
      currency: fields[21] as String,
      privacy: fields[22] as PrivacyType,
      brand: fields[23] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OfferDetailPostEntity obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.listId)
      ..writeByte(4)
      ..write(obj.currentLongitude)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.fileUrls)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.acceptOffers)
      ..writeByte(13)
      ..write(obj.sizeColors)
      ..writeByte(14)
      ..write(obj.currentLatitude)
      ..writeByte(15)
      ..write(obj.postId)
      ..writeByte(16)
      ..write(obj.deliveryType)
      ..writeByte(17)
      ..write(obj.price)
      ..writeByte(18)
      ..write(obj.minOfferAmount)
      ..writeByte(19)
      ..write(obj.condition)
      ..writeByte(20)
      ..write(obj.sizeChartUrl)
      ..writeByte(21)
      ..write(obj.currency)
      ..writeByte(22)
      ..write(obj.privacy)
      ..writeByte(23)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferDetailPostEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
