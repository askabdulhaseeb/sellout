// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageEntityAdapter extends TypeAdapter<MessageEntity> {
  @override
  final int typeId = 13;

  @override
  MessageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageEntity(
      persons: (fields[0] as List).cast<String>(),
      fileUrl: (fields[1] as List).cast<AttachmentEntity>(),
      updatedAt: fields[2] as DateTime,
      createdAt: fields[4] as DateTime,
      messageId: fields[5] as String,
      text: fields[6] as String,
      displayText: fields[8] as String,
      sendBy: fields[9] as String,
      chatId: fields[10] as String,
      visitingDetail: fields[3] as VisitingEntity?,
      type: fields[7] as MessageType?,
      source: fields[11] as String?,
      offerDetail: fields[12] as OfferDetailEntity?,
      quoteDetail: fields[13] as QuoteDetailEntity?,
      postDetail: fields[14] as MessagePostDetailEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageEntity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.persons)
      ..writeByte(1)
      ..write(obj.fileUrl)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.visitingDetail)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.messageId)
      ..writeByte(6)
      ..write(obj.text)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.displayText)
      ..writeByte(9)
      ..write(obj.sendBy)
      ..writeByte(10)
      ..write(obj.chatId)
      ..writeByte(11)
      ..write(obj.source)
      ..writeByte(12)
      ..write(obj.offerDetail)
      ..writeByte(13)
      ..write(obj.quoteDetail)
      ..writeByte(14)
      ..write(obj.postDetail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
