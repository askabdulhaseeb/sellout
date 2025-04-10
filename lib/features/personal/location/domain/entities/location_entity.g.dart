// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationEntityAdapter extends TypeAdapter<LocationEntity> {
  @override
  final int typeId = 17;

  @override
  LocationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationEntity(
      address: fields[3] as String?,
      id: fields[0] as String?,
      title: fields[2] as String?,
      url: fields[1] as String?,
      latitude: fields[4] as double?,
      longitude: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
