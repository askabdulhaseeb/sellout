// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusTypeAdapter extends TypeAdapter<StatusType> {
  @override
  final int typeId = 35;

  @override
  StatusType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatusType.pending;
      case 1:
        return StatusType.accepted;
      default:
        return StatusType.pending;
    }
  }

  @override
  void write(BinaryWriter writer, StatusType obj) {
    switch (obj) {
      case StatusType.pending:
        writer.writeByte(0);
        break;
      case StatusType.accepted:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
