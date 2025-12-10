// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryEntityAdapter extends TypeAdapter<CountryEntity> {
  @override
  final typeId = 51;

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
      countryName: fields[3] as String,
      countryCode: fields[4] as String,
      countryCodes: (fields[5] as List).cast<String>(),
      language: fields[6] as String,
      iosCode: fields[7] as String,
      isoCode: fields[8] as String,
      alpha2: fields[9] as String,
      alpha3: fields[10] as String,
      numberFormat: fields[11] as NumberFormatEntity,
      currency: fields[12] as String,
      isActive: fields[13] as bool,
      states: (fields[14] as List).cast<StateEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, CountryEntity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.flag)
      ..writeByte(1)
      ..write(obj.shortName)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.countryName)
      ..writeByte(4)
      ..write(obj.countryCode)
      ..writeByte(5)
      ..write(obj.countryCodes)
      ..writeByte(6)
      ..write(obj.language)
      ..writeByte(7)
      ..write(obj.iosCode)
      ..writeByte(8)
      ..write(obj.isoCode)
      ..writeByte(9)
      ..write(obj.alpha2)
      ..writeByte(10)
      ..write(obj.alpha3)
      ..writeByte(11)
      ..write(obj.numberFormat)
      ..writeByte(12)
      ..write(obj.currency)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.states);
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

class NumberFormatEntityAdapter extends TypeAdapter<NumberFormatEntity> {
  @override
  final typeId = 84;

  @override
  NumberFormatEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumberFormatEntity(
      format: fields[0] as String,
      regex: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NumberFormatEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.format)
      ..writeByte(1)
      ..write(obj.regex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberFormatEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StateEntityAdapter extends TypeAdapter<StateEntity> {
  @override
  final typeId = 85;

  @override
  StateEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateEntity(
      stateName: fields[0] as String,
      stateCode: fields[1] as String,
      cities: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, StateEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.stateName)
      ..writeByte(1)
      ..write(obj.stateCode)
      ..writeByte(2)
      ..write(obj.cities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
