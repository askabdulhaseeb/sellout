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
      quantity: fields[6] as int,
      address: fields[50] as String,
      isActive: fields[190] as bool,
      listID: fields[0] as String,
      currentLongitude: fields[30] as double,
      createdAt: fields[192] as DateTime,
      discount: fields[70] as bool,
      description: fields[4] as String,
      fileUrls: (fields[61] as List).cast<AttachmentEntity>(),
      title: fields[3] as String,
      type: fields[8] as ListingType,
      createdBy: fields[191] as String,
      acceptOffers: fields[9] as bool,
      sizeColors: (fields[71] as List).cast<SizeColorEntity>(),
      currentLatitude: fields[31] as double,
      postID: fields[1] as String,
      deliveryType: fields[13] as DeliveryType,
      price: fields[5] as double,
      minOfferAmount: fields[10] as double,
      condition: fields[12] as ConditionType,
      sizeChartUrl: fields[60] as AttachmentEntity?,
      currency: fields[7] as String?,
      privacy: fields[11] as PrivacyType,
      brand: fields[86] as String?,
      collectionLatitude: fields[32] as double?,
      collectionLongitude: fields[33] as double?,
      collectionLocation: fields[51] as LocationEntity?,
      localDelivery: fields[40] as int?,
      internationalDelivery: fields[41] as int?,
      fuelType: fields[89] as String?,
      doors: fields[81] as int?,
      availability: (fields[97] as List?)?.cast<AvailabilityEntity>(),
      emission: fields[88] as String?,
      exteriorColor: fields[94] as String?,
      seats: fields[82] as int?,
      vehiclesCategory: fields[95] as String?,
      meetUpLocation: fields[96] as LocationEntity?,
      interiorColor: fields[93] as String?,
      transmission: fields[92] as String?,
      mileage: fields[83] as int?,
      model: fields[85] as String?,
      engineSize: fields[90] as double?,
      make: fields[84] as String?,
      bodyType: fields[87] as String?,
      mileageUnit: fields[91] as String?,
      year: fields[80] as int?,
      petsCategory: fields[113] as String?,
      healthChecked: fields[112] as bool?,
      breed: fields[111] as String?,
      age: fields[110] as String?,
      vaccinationUpToDate: fields[116] as bool?,
      readyToLeave: fields[114] as String?,
      wormAndFleaTreated: fields[115] as bool?,
      accessCode: fields[193] as String?,
      businessID: fields[2] as String?,
      inHiveAt: fields[199] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PostEntity obj) {
    writer
      ..writeByte(56)
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
      ..write(obj.acceptOffers)
      ..writeByte(10)
      ..write(obj.minOfferAmount)
      ..writeByte(11)
      ..write(obj.privacy)
      ..writeByte(12)
      ..write(obj.condition)
      ..writeByte(13)
      ..write(obj.deliveryType)
      ..writeByte(30)
      ..write(obj.currentLongitude)
      ..writeByte(31)
      ..write(obj.currentLatitude)
      ..writeByte(32)
      ..write(obj.collectionLatitude)
      ..writeByte(33)
      ..write(obj.collectionLongitude)
      ..writeByte(40)
      ..write(obj.localDelivery)
      ..writeByte(41)
      ..write(obj.internationalDelivery)
      ..writeByte(50)
      ..write(obj.address)
      ..writeByte(51)
      ..write(obj.collectionLocation)
      ..writeByte(60)
      ..write(obj.sizeChartUrl)
      ..writeByte(61)
      ..write(obj.fileUrls)
      ..writeByte(70)
      ..write(obj.discount)
      ..writeByte(71)
      ..write(obj.sizeColors)
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
      ..writeByte(190)
      ..write(obj.isActive)
      ..writeByte(191)
      ..write(obj.createdBy)
      ..writeByte(192)
      ..write(obj.createdAt)
      ..writeByte(193)
      ..write(obj.accessCode)
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
