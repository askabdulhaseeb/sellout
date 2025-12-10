// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayTypeAdapter extends TypeAdapter<DayType> {
  @override
  final typeId = 32;

  @override
  DayType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DayType.monday;
      case 1:
        return DayType.tuesday;
      case 2:
        return DayType.wednesday;
      case 3:
        return DayType.thursday;
      case 4:
        return DayType.friday;
      case 5:
        return DayType.saturday;
      case 6:
        return DayType.sunday;
      default:
        return DayType.monday;
    }
  }

  @override
  void write(BinaryWriter writer, DayType obj) {
    switch (obj) {
      case DayType.monday:
        writer.writeByte(0);
      case DayType.tuesday:
        writer.writeByte(1);
      case DayType.wednesday:
        writer.writeByte(2);
      case DayType.thursday:
        writer.writeByte(3);
      case DayType.friday:
        writer.writeByte(4);
      case DayType.saturday:
        writer.writeByte(5);
      case DayType.sunday:
        writer.writeByte(6);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
