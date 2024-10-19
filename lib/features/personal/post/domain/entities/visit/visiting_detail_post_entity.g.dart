// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visiting_detail_post_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitingDetailPostEntityAdapter
    extends TypeAdapter<VisitingDetailPostEntity> {
  @override
  final int typeId = 15;

  @override
  VisitingDetailPostEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitingDetailPostEntity(
      listId: fields[0] as String,
      currentLongitude: fields[1] as double,
      year: fields[2] as int,
      vehiclesCategory: fields[3] as String,
      createdAt: fields[4] as DateTime,
      description: fields[5] as String,
      availability: (fields[6] as List).cast<AvailabilityEntity>(),
      fileUrls: (fields[7] as List).cast<AttachmentEntity>(),
      title: fields[8] as String,
      acceptOffers: fields[9] as String,
      seats: fields[10] as int,
      emission: fields[11] as String,
      transmission: fields[12] as String,
      price: fields[13] as int,
      condition: fields[14] as ConditionType,
      bodyType: fields[15] as String,
      currency: fields[16] as String,
      model: fields[17] as String,
      privacy: fields[18] as PrivacyType,
      make: fields[20] as String,
      mileage: fields[21] as int,
      address: fields[22] as String,
      isActive: fields[23] as bool,
      interiorColor: fields[24] as String,
      createdBy: fields[25] as String,
      doors: fields[26] as int,
      currentLatitude: fields[27] as double,
      mileageUnit: fields[28] as String,
      postId: fields[29] as String,
      exteriorColor: fields[30] as String,
      meetUpLocation: fields[31] as LocationEntity,
      engineSize: fields[32] as double,
      fuelType: fields[19] as String?,
      accessCode: fields[33] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitingDetailPostEntity obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.listId)
      ..writeByte(1)
      ..write(obj.currentLongitude)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.vehiclesCategory)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.availability)
      ..writeByte(7)
      ..write(obj.fileUrls)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.acceptOffers)
      ..writeByte(10)
      ..write(obj.seats)
      ..writeByte(11)
      ..write(obj.emission)
      ..writeByte(12)
      ..write(obj.transmission)
      ..writeByte(13)
      ..write(obj.price)
      ..writeByte(14)
      ..write(obj.condition)
      ..writeByte(15)
      ..write(obj.bodyType)
      ..writeByte(16)
      ..write(obj.currency)
      ..writeByte(17)
      ..write(obj.model)
      ..writeByte(18)
      ..write(obj.privacy)
      ..writeByte(19)
      ..write(obj.fuelType)
      ..writeByte(20)
      ..write(obj.make)
      ..writeByte(21)
      ..write(obj.mileage)
      ..writeByte(22)
      ..write(obj.address)
      ..writeByte(23)
      ..write(obj.isActive)
      ..writeByte(24)
      ..write(obj.interiorColor)
      ..writeByte(25)
      ..write(obj.createdBy)
      ..writeByte(26)
      ..write(obj.doors)
      ..writeByte(27)
      ..write(obj.currentLatitude)
      ..writeByte(28)
      ..write(obj.mileageUnit)
      ..writeByte(29)
      ..write(obj.postId)
      ..writeByte(30)
      ..write(obj.exteriorColor)
      ..writeByte(31)
      ..write(obj.meetUpLocation)
      ..writeByte(32)
      ..write(obj.engineSize)
      ..writeByte(33)
      ..write(obj.accessCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitingDetailPostEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
