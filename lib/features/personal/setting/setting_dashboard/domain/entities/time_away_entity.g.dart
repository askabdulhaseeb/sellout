// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_away_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeAwayEntityAdapter extends TypeAdapter<TimeAwayEntity> {
  @override
  final int typeId = 64;

  @override
  TimeAwayEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeAwayEntity(
      startDate: fields[0] as String?,
      endDate: fields[1] as String?,
      message: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TimeAwayEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeAwayEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
