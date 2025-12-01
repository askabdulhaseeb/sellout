// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressEntityAdapter extends TypeAdapter<AddressEntity> {
  @override
  final typeId = 6;

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
      address1: fields[3] as String,
      address2: fields[4] as String,
      category: fields[5] as String,
      postalCode: fields[6] as String,
      city: fields[7] as String,
      state: fields[8] as StateEntity?,
      country: fields[9] as CountryEntity,
      isDefault: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AddressEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.addressID)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.recipientName)
      ..writeByte(3)
      ..write(obj.address1)
      ..writeByte(4)
      ..write(obj.address2)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.postalCode)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.country)
      ..writeByte(10)
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
