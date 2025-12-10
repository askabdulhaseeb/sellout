// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_condition_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConditionTypeAdapter extends TypeAdapter<ConditionType> {
  @override
  final typeId = 25;

  @override
  ConditionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConditionType.newC;
      case 1:
        return ConditionType.used;
      default:
        return ConditionType.newC;
    }
  }

  @override
  void write(BinaryWriter writer, ConditionType obj) {
    switch (obj) {
      case ConditionType.newC:
        writer.writeByte(0);
      case ConditionType.used:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
