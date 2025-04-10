// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_travel_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessTravelDetailEntityAdapter
    extends TypeAdapter<BusinessTravelDetailEntity> {
  @override
  final int typeId = 40;

  @override
  BusinessTravelDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessTravelDetailEntity(
      currency: fields[0] as String?,
      maxTravelTime: fields[1] as int?,
      timeType: fields[2] as String?,
      maxTravel: fields[3] as int?,
      travelFee: fields[4] as double?,
      distance: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessTravelDetailEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currency)
      ..writeByte(1)
      ..write(obj.maxTravelTime)
      ..writeByte(2)
      ..write(obj.timeType)
      ..writeByte(3)
      ..write(obj.maxTravel)
      ..writeByte(4)
      ..write(obj.travelFee)
      ..writeByte(5)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTravelDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
