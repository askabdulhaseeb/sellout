// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatEntityAdapter extends TypeAdapter<ChatEntity> {
  @override
  final int typeId = 10;

  @override
  ChatEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatEntity(
      updatedAt: fields[0] as DateTime,
      createdAt: fields[1] as DateTime,
      ids: (fields[3] as List).cast<String>(),
      createdBy: fields[4] as String,
      lastMessage: fields[5] as MessageEntity?,
      persons: (fields[7] as List).cast<String>(),
      chatId: fields[8] as String,
      type: fields[9] as ChatType,
      productInfo: fields[6] as OfferAmountInfoEntity?,
      participants: (fields[2] as List?)?.cast<ChatParticipantEntity>(),
      deletedBy: (fields[10] as List?)?.cast<dynamic>(),
      groupInfo: fields[11] as GroupInfoEntity?,
      pinnedMessage: fields[14] as MessageEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.updatedAt)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.participants)
      ..writeByte(3)
      ..write(obj.ids)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.lastMessage)
      ..writeByte(6)
      ..write(obj.productInfo)
      ..writeByte(7)
      ..write(obj.persons)
      ..writeByte(8)
      ..write(obj.chatId)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.deletedBy)
      ..writeByte(11)
      ..write(obj.groupInfo)
      ..writeByte(14)
      ..write(obj.pinnedMessage)
      ..writeByte(99)
      ..write(obj.inHiveAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
