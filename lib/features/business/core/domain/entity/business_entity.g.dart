// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessEntityAdapter extends TypeAdapter<BusinessEntity> {
  @override
  final int typeId = 39;

  @override
  BusinessEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessEntity(
      businessID: fields[0] as String,
      location: fields[1] as LocationEntity,
      acceptPromotions: fields[2] as bool,
      locationType: fields[3] as String,
      travelDetail: fields[4] as BusinessTravelDetailEntity,
      employees: (fields[5] as List).cast<BusinessEmployeeEntity>(),
      address: fields[6] as BusinessAddressEntity,
      displayName: fields[7] as String,
      ownerID: fields[8] as String,
      tagline: fields[9] as String,
      phoneNumber: fields[10] as String,
      companyNo: fields[11] as String,
      routine: (fields[12] as List).cast<RoutineEntity>(),
      listOfReviews: (fields[13] as List).cast<double>(),
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
      logo: fields[16] as AttachmentEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessEntity obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.businessID)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.acceptPromotions)
      ..writeByte(3)
      ..write(obj.locationType)
      ..writeByte(4)
      ..write(obj.travelDetail)
      ..writeByte(5)
      ..write(obj.employees)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.displayName)
      ..writeByte(8)
      ..write(obj.ownerID)
      ..writeByte(9)
      ..write(obj.tagline)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.companyNo)
      ..writeByte(12)
      ..write(obj.routine)
      ..writeByte(13)
      ..write(obj.listOfReviews)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
