// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean_status_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BooleanStatusTypeAdapter extends TypeAdapter<BooleanStatusType> {
  @override
  final int typeId = 31;

  @override
  BooleanStatusType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BooleanStatusType.yes;
      case 1:
        return BooleanStatusType.no;
      default:
        return BooleanStatusType.yes;
    }
  }

  @override
  void write(BinaryWriter writer, BooleanStatusType obj) {
    switch (obj) {
      case BooleanStatusType.yes:
        writer.writeByte(0);
        break;
      case BooleanStatusType.no:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooleanStatusTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
