// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final typeId = 18;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.image;
      case 2:
        return MessageType.video;
      case 3:
        return MessageType.audio;
      case 4:
        return MessageType.file;
      case 5:
        return MessageType.location;
      case 6:
        return MessageType.contact;
      case 7:
        return MessageType.sticker;
      case 8:
        return MessageType.custom;
      case 9:
        return MessageType.invitationParticipant;
      case 10:
        return MessageType.offer;
      case 11:
        return MessageType.visiting;
      case 12:
        return MessageType.acceptInvitation;
      case 13:
        return MessageType.removeParticipant;
      case 14:
        return MessageType.leaveGroup;
      case 15:
        return MessageType.simple;
      case 16:
        return MessageType.requestQuote;
      case 17:
        return MessageType.quote;
      case 18:
        return MessageType.inquiry;
      case 99:
        return MessageType.none;
      default:
        return MessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.text:
        writer.writeByte(0);
      case MessageType.image:
        writer.writeByte(1);
      case MessageType.video:
        writer.writeByte(2);
      case MessageType.audio:
        writer.writeByte(3);
      case MessageType.file:
        writer.writeByte(4);
      case MessageType.location:
        writer.writeByte(5);
      case MessageType.contact:
        writer.writeByte(6);
      case MessageType.sticker:
        writer.writeByte(7);
      case MessageType.custom:
        writer.writeByte(8);
      case MessageType.invitationParticipant:
        writer.writeByte(9);
      case MessageType.offer:
        writer.writeByte(10);
      case MessageType.visiting:
        writer.writeByte(11);
      case MessageType.acceptInvitation:
        writer.writeByte(12);
      case MessageType.removeParticipant:
        writer.writeByte(13);
      case MessageType.leaveGroup:
        writer.writeByte(14);
      case MessageType.simple:
        writer.writeByte(15);
      case MessageType.requestQuote:
        writer.writeByte(16);
      case MessageType.quote:
        writer.writeByte(17);
      case MessageType.inquiry:
        writer.writeByte(18);
      case MessageType.none:
        writer.writeByte(99);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
