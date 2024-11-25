// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_address_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessAddressEntityAdapter extends TypeAdapter<BusinessAddressEntity> {
  @override
  final int typeId = 43;

  @override
  BusinessAddressEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessAddressEntity(
      city: fields[0] as String,
      postalCode: fields[1] as int,
      firstAddress: fields[2] as String,
      secondaryAddress: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessAddressEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.postalCode)
      ..writeByte(2)
      ..write(obj.firstAddress)
      ..writeByte(3)
      ..write(obj.secondaryAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAddressEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
