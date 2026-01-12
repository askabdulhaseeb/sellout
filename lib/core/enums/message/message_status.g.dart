// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageStatusAdapter extends TypeAdapter<MessageStatus> {
  @override
  final typeId = 96;

  @override
  MessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatus.pending;
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.delivered;
      case 3:
        return MessageStatus.read;
      case 4:
        return MessageStatus.failed;
      default:
        return MessageStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    switch (obj) {
      case MessageStatus.pending:
        writer.writeByte(0);
      case MessageStatus.sent:
        writer.writeByte(1);
      case MessageStatus.delivered:
        writer.writeByte(2);
      case MessageStatus.read:
        writer.writeByte(3);
      case MessageStatus.failed:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
