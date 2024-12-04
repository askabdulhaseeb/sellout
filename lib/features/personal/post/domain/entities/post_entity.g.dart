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
      quantity: fields[0] as int,
      address: fields[1] as String,
      isActive: fields[2] as bool,
      listId: fields[3] as String,
      currentLongitude: fields[4] as double,
      createdAt: fields[5] as DateTime,
      discount: fields[6] as DiscountEntity?,
      description: fields[7] as String,
      fileUrls: (fields[8] as List).cast<AttachmentEntity>(),
      title: fields[9] as String,
      type: fields[10] as ListingType,
      createdBy: fields[11] as String,
      acceptOffers: fields[12] as BooleanStatusType,
      sizeColors: (fields[13] as List).cast<SizeColorEntity>(),
      currentLatitude: fields[14] as double,
      postId: fields[15] as String,
      deliveryType: fields[16] as DeliveryType,
      price: fields[17] as double,
      minOfferAmount: fields[18] as double,
      condition: fields[19] as ConditionType,
      sizeChartUrl: fields[20] as AttachmentEntity?,
      currency: fields[21] as String?,
      privacy: fields[22] as PrivacyType,
      brand: fields[23] as String?,
      collectionLatitude: fields[24] as double?,
      collectionLongitude: fields[25] as double?,
      collectionLocation: fields[26] as LocationEntity?,
      localDelivery: fields[27] as int?,
      internationalDelivery: fields[28] as int?,
      fuelType: fields[29] as String?,
      doors: fields[30] as int?,
      availability: (fields[31] as List?)?.cast<AvailabilityEntity>(),
      emission: fields[32] as String?,
      exteriorColor: fields[33] as String?,
      seats: fields[34] as int?,
      vehiclesCategory: fields[35] as String?,
      meetUpLocation: fields[36] as LocationEntity?,
      interiorColor: fields[37] as String?,
      transmission: fields[38] as String?,
      mileage: fields[39] as int?,
      model: fields[40] as String?,
      engineSize: fields[41] as double?,
      make: fields[42] as String?,
      bodyType: fields[43] as String?,
      mileageUnit: fields[44] as String?,
      year: fields[45] as int?,
      petsCategory: fields[46] as String?,
      healthChecked: fields[47] as BooleanStatusType?,
      breed: fields[48] as String?,
      age: fields[49] as String?,
      vaccinationUpToDate: fields[50] as BooleanStatusType?,
      readyToLeave: fields[51] as String?,
      wormAndFleaTreated: fields[52] as BooleanStatusType?,
      accessCode: fields[53] as String?,
      businessID: fields[54] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostEntity obj) {
    writer
      ..writeByte(55)
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
      ..write(obj.brand)
      ..writeByte(24)
      ..write(obj.collectionLatitude)
      ..writeByte(25)
      ..write(obj.collectionLongitude)
      ..writeByte(26)
      ..write(obj.collectionLocation)
      ..writeByte(27)
      ..write(obj.localDelivery)
      ..writeByte(28)
      ..write(obj.internationalDelivery)
      ..writeByte(29)
      ..write(obj.fuelType)
      ..writeByte(30)
      ..write(obj.doors)
      ..writeByte(31)
      ..write(obj.availability)
      ..writeByte(32)
      ..write(obj.emission)
      ..writeByte(33)
      ..write(obj.exteriorColor)
      ..writeByte(34)
      ..write(obj.seats)
      ..writeByte(35)
      ..write(obj.vehiclesCategory)
      ..writeByte(36)
      ..write(obj.meetUpLocation)
      ..writeByte(37)
      ..write(obj.interiorColor)
      ..writeByte(38)
      ..write(obj.transmission)
      ..writeByte(39)
      ..write(obj.mileage)
      ..writeByte(40)
      ..write(obj.model)
      ..writeByte(41)
      ..write(obj.engineSize)
      ..writeByte(42)
      ..write(obj.make)
      ..writeByte(43)
      ..write(obj.bodyType)
      ..writeByte(44)
      ..write(obj.mileageUnit)
      ..writeByte(45)
      ..write(obj.year)
      ..writeByte(46)
      ..write(obj.petsCategory)
      ..writeByte(47)
      ..write(obj.healthChecked)
      ..writeByte(48)
      ..write(obj.breed)
      ..writeByte(49)
      ..write(obj.age)
      ..writeByte(50)
      ..write(obj.vaccinationUpToDate)
      ..writeByte(51)
      ..write(obj.readyToLeave)
      ..writeByte(52)
      ..write(obj.wormAndFleaTreated)
      ..writeByte(53)
      ..write(obj.accessCode)
      ..writeByte(54)
      ..write(obj.businessID);
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
