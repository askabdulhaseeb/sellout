// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatTypeAdapter extends TypeAdapter<ChatType> {
  @override
  final typeId = 28;

  @override
  ChatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatType.private;
      case 1:
        return ChatType.product;
      case 2:
        return ChatType.group;
      case 3:
        return ChatType.service;
      case 4:
        return ChatType.requestQuote;
      default:
        return ChatType.private;
    }
  }

  @override
  void write(BinaryWriter writer, ChatType obj) {
    switch (obj) {
      case ChatType.private:
        writer.writeByte(0);
      case ChatType.product:
        writer.writeByte(1);
      case ChatType.group:
        writer.writeByte(2);
      case ChatType.service:
        writer.writeByte(3);
      case ChatType.requestQuote:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
