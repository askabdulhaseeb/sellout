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
        return StatusType.inprogress;
      case 2:
        return StatusType.accepted;
      case 3:
        return StatusType.rejected;
      case 4:
        return StatusType.cancelled;
      case 5:
        return StatusType.completed;
      case 6:
        return StatusType.delivered;
      case 7:
        return StatusType.shipped;
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
      case StatusType.inprogress:
        writer.writeByte(1);
        break;
      case StatusType.accepted:
        writer.writeByte(2);
        break;
      case StatusType.rejected:
        writer.writeByte(3);
        break;
      case StatusType.cancelled:
        writer.writeByte(4);
        break;
      case StatusType.completed:
        writer.writeByte(5);
        break;
      case StatusType.delivered:
        writer.writeByte(6);
        break;
      case StatusType.shipped:
        writer.writeByte(7);
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
