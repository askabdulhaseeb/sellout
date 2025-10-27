// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostEntityAdapter extends TypeAdapter<PostEntity> {
  @override
  final int typeId = 20;

  @override
  PostEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostEntity(
      listID: fields[0] as String,
      postID: fields[1] as String,
      businessID: fields[2] as String?,
      title: fields[3] as String,
      description: fields[4] as String,
      price: fields[5] as double,
      quantity: fields[6] as int,
      currency: fields[7] as String?,
      type: fields[8] as ListingType,
      acceptOffers: fields[10] as bool,
      minOfferAmount: fields[11] as double,
      privacy: fields[12] as PrivacyType,
      condition: fields[13] as ConditionType,
      listOfReviews: (fields[15] as List?)?.cast<double>(),
      categoryType: fields[16] as String,
      currentLongitude: fields[20] as double,
      currentLatitude: fields[21] as double,
      collectionLatitude: fields[22] as double?,
      collectionLongitude: fields[23] as double?,
      collectionLocation: fields[24] as LocationEntity?,
      meetUpLocation: fields[25] as LocationEntity?,
      deliveryType: fields[14] as DeliveryType,
      localDelivery: fields[26] as int?,
      internationalDelivery: fields[27] as int?,
      availability: (fields[35] as List?)?.cast<AvailabilityEntity>(),
      fileUrls: (fields[17] as List).cast<AttachmentEntity>(),
      hasDiscount: fields[19] as bool,
      discounts: (fields[18] as List).cast<DiscountEntity>(),
      clothFootInfo: fields[28] as PostClothFootEntity?,
      propertyInfo: fields[31] as PostPropertyEntity?,
      petInfo: fields[30] as PostPetEntity?,
      vehicleInfo: fields[29] as PostVehicleEntity?,
      foodDrinkInfo: fields[32] as PostFoodDrinkEntity?,
      itemInfo: fields[33] as PostItemEntity?,
      packageDetail: fields[34] as PackageDetailEntity,
      isActive: fields[36] as bool,
      createdBy: fields[37] as String,
      updatedBy: fields[40] == null ? '' : fields[40] as String,
      createdAt: fields[38] as DateTime,
      updatedAt: fields[41] as DateTime?,
      accessCode: fields[39] as String?,
      inHiveAt: fields[42] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PostEntity obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.listID)
      ..writeByte(1)
      ..write(obj.postID)
      ..writeByte(2)
      ..write(obj.businessID)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.acceptOffers)
      ..writeByte(11)
      ..write(obj.minOfferAmount)
      ..writeByte(12)
      ..write(obj.privacy)
      ..writeByte(13)
      ..write(obj.condition)
      ..writeByte(14)
      ..write(obj.deliveryType)
      ..writeByte(15)
      ..write(obj.listOfReviews)
      ..writeByte(16)
      ..write(obj.categoryType)
      ..writeByte(17)
      ..write(obj.fileUrls)
      ..writeByte(18)
      ..write(obj.discounts)
      ..writeByte(19)
      ..write(obj.hasDiscount)
      ..writeByte(20)
      ..write(obj.currentLongitude)
      ..writeByte(21)
      ..write(obj.currentLatitude)
      ..writeByte(22)
      ..write(obj.collectionLatitude)
      ..writeByte(23)
      ..write(obj.collectionLongitude)
      ..writeByte(24)
      ..write(obj.collectionLocation)
      ..writeByte(25)
      ..write(obj.meetUpLocation)
      ..writeByte(26)
      ..write(obj.localDelivery)
      ..writeByte(27)
      ..write(obj.internationalDelivery)
      ..writeByte(28)
      ..write(obj.clothFootInfo)
      ..writeByte(29)
      ..write(obj.vehicleInfo)
      ..writeByte(30)
      ..write(obj.petInfo)
      ..writeByte(31)
      ..write(obj.propertyInfo)
      ..writeByte(32)
      ..write(obj.foodDrinkInfo)
      ..writeByte(33)
      ..write(obj.itemInfo)
      ..writeByte(34)
      ..write(obj.packageDetail)
      ..writeByte(35)
      ..write(obj.availability)
      ..writeByte(36)
      ..write(obj.isActive)
      ..writeByte(37)
      ..write(obj.createdBy)
      ..writeByte(38)
      ..write(obj.createdAt)
      ..writeByte(39)
      ..write(obj.accessCode)
      ..writeByte(40)
      ..write(obj.updatedBy)
      ..writeByte(41)
      ..write(obj.updatedAt)
      ..writeByte(42)
      ..write(obj.inHiveAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
