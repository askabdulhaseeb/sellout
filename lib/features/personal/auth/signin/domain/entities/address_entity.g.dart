// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressEntityAdapter extends TypeAdapter<AddressEntity> {
  @override
  final int typeId = 6;

  @override
  AddressEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressEntity(
      addressID: fields[0] as String,
      phoneNumber: fields[1] as String,
      recipientName: fields[2] as String,
      address: fields[3] as String,
      category: fields[4] as String,
      postalCode: fields[5] as String,
      city: fields[6] as String,
      state: fields[9] as StateEntity,
      country: fields[7] as CountryEntity,
      isDefault: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AddressEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.addressID)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.recipientName)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
