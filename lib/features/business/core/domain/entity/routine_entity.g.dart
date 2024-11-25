// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineEntityAdapter extends TypeAdapter<RoutineEntity> {
  @override
  final int typeId = 42;

  @override
  RoutineEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineEntity(
      day: fields[0] as DayType,
      isOpen: fields[1] as bool,
      closing: fields[2] as String?,
      opening: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.isOpen)
      ..writeByte(2)
      ..write(obj.closing)
      ..writeByte(3)
      ..write(obj.opening);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
