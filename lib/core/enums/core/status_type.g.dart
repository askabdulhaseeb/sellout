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
      case 11:
        return StatusType.inprogress;
      case 12:
        return StatusType.inActive;
      case 21:
        return StatusType.blocked;
      case 22:
        return StatusType.rejected;
      case 23:
        return StatusType.cancelled;
      case 31:
        return StatusType.accepted;
      case 32:
        return StatusType.completed;
      case 33:
        return StatusType.delivered;
      case 34:
        return StatusType.shipped;
      case 35:
        return StatusType.active;
      case 36:
        return StatusType.onHold;
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
        writer.writeByte(11);
        break;
      case StatusType.inActive:
        writer.writeByte(12);
        break;
      case StatusType.blocked:
        writer.writeByte(21);
        break;
      case StatusType.rejected:
        writer.writeByte(22);
        break;
      case StatusType.cancelled:
        writer.writeByte(23);
        break;
      case StatusType.accepted:
        writer.writeByte(31);
        break;
      case StatusType.completed:
        writer.writeByte(32);
        break;
      case StatusType.delivered:
        writer.writeByte(33);
        break;
      case StatusType.shipped:
        writer.writeByte(34);
        break;
      case StatusType.active:
        writer.writeByte(35);
        break;
      case StatusType.onHold:
        writer.writeByte(36);
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
