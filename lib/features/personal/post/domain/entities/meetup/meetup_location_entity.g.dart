// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetup_location_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetUpLocationEntityAdapter extends TypeAdapter<MeetUpLocationEntity> {
  @override
  final int typeId = 17;

  @override
  MeetUpLocationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetUpLocationEntity(
      address: fields[0] as String,
      id: fields[1] as String,
      title: fields[2] as String,
      url: fields[3] as String,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MeetUpLocationEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.url)
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
      other is MeetUpLocationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
