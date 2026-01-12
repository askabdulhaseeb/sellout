// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusTypeAdapter extends TypeAdapter<StatusType> {
  @override
  final typeId = 35;

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
      case 24:
        return StatusType.canceled;
      case 25:
        return StatusType.rejectedBySeller;
      case 26:
        return StatusType.returned;
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
      case 37:
        return StatusType.processing;
      case 38:
        return StatusType.readyToShip;
      case 39:
        return StatusType.paid;
      case 40:
        return StatusType.succeeded;
      case 41:
        return StatusType.released;
      case 42:
        return StatusType.authorized;
      default:
        return StatusType.pending;
    }
  }

  @override
  void write(BinaryWriter writer, StatusType obj) {
    switch (obj) {
      case StatusType.pending:
        writer.writeByte(0);
      case StatusType.inprogress:
        writer.writeByte(11);
      case StatusType.inActive:
        writer.writeByte(12);
      case StatusType.blocked:
        writer.writeByte(21);
      case StatusType.rejected:
        writer.writeByte(22);
      case StatusType.cancelled:
        writer.writeByte(23);
      case StatusType.canceled:
        writer.writeByte(24);
      case StatusType.rejectedBySeller:
        writer.writeByte(25);
      case StatusType.returned:
        writer.writeByte(26);
      case StatusType.accepted:
        writer.writeByte(31);
      case StatusType.completed:
        writer.writeByte(32);
      case StatusType.delivered:
        writer.writeByte(33);
      case StatusType.shipped:
        writer.writeByte(34);
      case StatusType.active:
        writer.writeByte(35);
      case StatusType.onHold:
        writer.writeByte(36);
      case StatusType.processing:
        writer.writeByte(37);
      case StatusType.readyToShip:
        writer.writeByte(38);
      case StatusType.paid:
        writer.writeByte(39);
      case StatusType.succeeded:
        writer.writeByte(40);
      case StatusType.released:
        writer.writeByte(41);
      case StatusType.authorized:
        writer.writeByte(42);
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
