// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryEntityAdapter extends TypeAdapter<CountryEntity> {
  @override
  final int typeId = 51;

  @override
  CountryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryEntity(
      flag: fields[0] as String,
      shortName: fields[1] as String,
      displayName: fields[2] as String,
      countryCode: fields[3] as String,
      numberFormat: fields[4] as String,
      currency: (fields[5] as List).cast<String>(),
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CountryEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.flag)
      ..writeByte(1)
      ..write(obj.shortName)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.numberFormat)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
