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
      address: fields[9] as String,
      acceptOffers: fields[10] as bool,
      minOfferAmount: fields[11] as double,
      privacy: fields[12] as PrivacyType,
      condition: fields[13] as ConditionType,
      deliveryType: fields[14] as DeliveryType,
      listOfReviews: (fields[15] as List?)?.cast<double>(),
      categoryType: fields[16] as String,
      currentLongitude: fields[30] as double,
      currentLatitude: fields[31] as double,
      collectionLatitude: fields[32] as double?,
      collectionLongitude: fields[33] as double?,
      collectionLocation: fields[34] as LocationEntity?,
      localDelivery: fields[40] as int?,
      internationalDelivery: fields[41] as int?,
      sizeChartUrl: fields[60] as AttachmentEntity?,
      fileUrls: (fields[61] as List).cast<AttachmentEntity>(),
      hasDiscount: fields[70] as bool,
      discounts: (fields[72] as List).cast<DiscountEntity>(),
      sizeColors: (fields[71] as List).cast<SizeColorEntity>(),
      year: fields[80] as int?,
      doors: fields[81] as int?,
      seats: fields[82] as int?,
      mileage: fields[83] as int?,
      make: fields[84] as String?,
      model: fields[85] as String?,
      brand: fields[86] as String?,
      bodyType: fields[87] as String?,
      emission: fields[88] as String?,
      fuelType: fields[89] as String?,
      engineSize: fields[90] as double?,
      mileageUnit: fields[91] as String?,
      transmission: fields[92] as String?,
      interiorColor: fields[93] as String?,
      exteriorColor: fields[94] as String?,
      vehiclesCategory: fields[95] as String?,
      meetUpLocation: fields[96] as LocationEntity?,
      availability: (fields[97] as List?)?.cast<AvailabilityEntity>(),
      age: fields[110] as String?,
      breed: fields[111] as String?,
      healthChecked: fields[112] as bool?,
      petsCategory: fields[113] as String?,
      readyToLeave: fields[114] as String?,
      wormAndFleaTreated: fields[115] as bool?,
      vaccinationUpToDate: fields[116] as bool?,
      propertytype: fields[117] as String?,
      propertyCategory: fields[118] as String?,
      isActive: fields[190] as bool,
      createdBy: fields[191] as String,
      updatedBy: fields[194] == null ? '' : fields[194] as String,
      createdAt: fields[192] as DateTime,
      updatedAt: fields[195] as DateTime?,
      accessCode: fields[193] as String?,
      inHiveAt: fields[199] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PostEntity obj) {
    writer
      ..writeByte(63)
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
      ..writeByte(9)
      ..write(obj.address)
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
      ..writeByte(30)
      ..write(obj.currentLongitude)
      ..writeByte(31)
      ..write(obj.currentLatitude)
      ..writeByte(32)
      ..write(obj.collectionLatitude)
      ..writeByte(33)
      ..write(obj.collectionLongitude)
      ..writeByte(34)
      ..write(obj.collectionLocation)
      ..writeByte(40)
      ..write(obj.localDelivery)
      ..writeByte(41)
      ..write(obj.internationalDelivery)
      ..writeByte(60)
      ..write(obj.sizeChartUrl)
      ..writeByte(61)
      ..write(obj.fileUrls)
      ..writeByte(70)
      ..write(obj.hasDiscount)
      ..writeByte(71)
      ..write(obj.sizeColors)
      ..writeByte(72)
      ..write(obj.discounts)
      ..writeByte(80)
      ..write(obj.year)
      ..writeByte(81)
      ..write(obj.doors)
      ..writeByte(82)
      ..write(obj.seats)
      ..writeByte(83)
      ..write(obj.mileage)
      ..writeByte(84)
      ..write(obj.make)
      ..writeByte(85)
      ..write(obj.model)
      ..writeByte(86)
      ..write(obj.brand)
      ..writeByte(87)
      ..write(obj.bodyType)
      ..writeByte(88)
      ..write(obj.emission)
      ..writeByte(89)
      ..write(obj.fuelType)
      ..writeByte(90)
      ..write(obj.engineSize)
      ..writeByte(91)
      ..write(obj.mileageUnit)
      ..writeByte(92)
      ..write(obj.transmission)
      ..writeByte(93)
      ..write(obj.interiorColor)
      ..writeByte(94)
      ..write(obj.exteriorColor)
      ..writeByte(95)
      ..write(obj.vehiclesCategory)
      ..writeByte(96)
      ..write(obj.meetUpLocation)
      ..writeByte(97)
      ..write(obj.availability)
      ..writeByte(110)
      ..write(obj.age)
      ..writeByte(111)
      ..write(obj.breed)
      ..writeByte(112)
      ..write(obj.healthChecked)
      ..writeByte(113)
      ..write(obj.petsCategory)
      ..writeByte(114)
      ..write(obj.readyToLeave)
      ..writeByte(115)
      ..write(obj.wormAndFleaTreated)
      ..writeByte(116)
      ..write(obj.vaccinationUpToDate)
      ..writeByte(117)
      ..write(obj.propertytype)
      ..writeByte(118)
      ..write(obj.propertyCategory)
      ..writeByte(190)
      ..write(obj.isActive)
      ..writeByte(191)
      ..write(obj.createdBy)
      ..writeByte(192)
      ..write(obj.createdAt)
      ..writeByte(193)
      ..write(obj.accessCode)
      ..writeByte(194)
      ..write(obj.updatedBy)
      ..writeByte(195)
      ..write(obj.updatedAt)
      ..writeByte(199)
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
