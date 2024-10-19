// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvailabilityEntityAdapter extends TypeAdapter<AvailabilityEntity> {
  @override
  final int typeId = 16;

  @override
  AvailabilityEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvailabilityEntity(
      day: fields[0] as DayType,
      isOpen: fields[1] as bool,
      closingTime: fields[2] as String,
      openingTime: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AvailabilityEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.isOpen)
      ..writeByte(2)
      ..write(obj.closingTime)
      ..writeByte(3)
      ..write(obj.openingTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailabilityEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
