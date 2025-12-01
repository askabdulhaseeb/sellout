import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';

// getOnlineUsers
class LocalChatMessage {
  static final String boxTitle = AppStrings.localChatMessagesBox;

  static Box<GettedMessageEntity> get _box =>
      Hive.box<GettedMessageEntity>(boxTitle);

  static Box<GettedMessageEntity> get boxLive => _box;

  static Future<Box<GettedMessageEntity>> get openBox async =>
      await Hive.openBox<GettedMessageEntity>(boxTitle);

  Future<Box<GettedMessageEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<GettedMessageEntity>(boxTitle);
    }
  }

  Future<void> clear() async => await _box.clear();

  Future<void> saveMessage(MessageEntity message) async {
    final String chatId = message.chatId;
    final GettedMessageEntity? existingEntity = _box.get(chatId);
    if (existingEntity == null) {
      final GettedMessageEntity newEntity = GettedMessageEntity(
        chatID: chatId,
        messages: <MessageEntity>[message],
        lastEvaluatedKey: null,
      );

      await _box.put(chatId, newEntity);
      await LocalChat().updateLastMessage(chatId, newEntity.messages.last);
      LocalUnreadMessagesService().increment(chatId);

      AppLog.info('🆕 New chat saved with 1 message.');
    } else {
      await updateMessage(chatId, message);
    }
  }

  Future<void> updateMessage(String chatId, MessageEntity newMessage) async {
    final GettedMessageEntity? entity = _box.get(chatId);
    if (entity == null) return;

    final List<MessageEntity> updatedMessages = List<MessageEntity>.from(
      entity.messages,
    );

    final int existingIndex = updatedMessages.indexWhere(
      (MessageEntity msg) => msg.messageId == newMessage.messageId,
    );

    if (existingIndex != -1) {
      updatedMessages[existingIndex] = newMessage;
      AppLog.info('✏️ Message updated in local DB');
    } else {
      updatedMessages.add(newMessage);
      LocalUnreadMessagesService().increment(chatId);
      await LocalChat().updateLastMessage(chatId, newMessage);
      AppLog.info('➕ Message added to existing chat');
    }

    final GettedMessageEntity updatedEntity = entity.copyWith(
      messages: updatedMessages,
    );
    await _box.put(chatId, updatedEntity);
  }

  Future<void> save(GettedMessageEntity value, String chatID) async {
    final String id = value.lastEvaluatedKey?.chatID ?? chatID;
    final GettedMessageEntity? result = entity(id);
    if (result == null) {
      await _put(id, value);
      return;
    } else {
      final List<MessageEntity> old = result.messages;
      final List<MessageEntity> neww = value.messages;
      AppLog.info(
        'New Message - old: ${old.length} - new: ${neww.length}',
        name: chatID,
      );
      // if (old.length != neww.length) {
      for (MessageEntity element in neww) {
        if (old.any((MessageEntity e) => e.messageId == element.messageId)) {
          continue;
        } else {
          old.add(element);
        }
        // }
      }
      AppLog.info('New Message - updated: ${old.length}', name: chatID);
      final GettedMessageEntity newGettedMessage = GettedMessageEntity(
        chatID: id,
        messages: old,
        lastEvaluatedKey: value.lastEvaluatedKey,
      );
      await _put(id, newGettedMessage);
    }
  }

  Future<void> update(GettedMessageEntity value, String chatID) async {
    await _put(chatID, value);
    AppLog.info('✅ Replaced GettedMessageEntity for chatID: $chatID');
  }

  Future<void> _put(String key, GettedMessageEntity value) async {
    await _box.put(key, value);
  }

  GettedMessageEntity? entity(String value) => _box.get(value);

  List<MessageEntity> messages(String value) {
    final List<GettedMessageEntity> getted = _box.values
        .where((GettedMessageEntity element) => element.chatID == value)
        .toList();
    if (getted.isEmpty) return <MessageEntity>[];
    final List<MessageEntity> msgs = getted[0].messages;
    msgs.sort(
      (MessageEntity a, MessageEntity b) => b.createdAt.compareTo(a.createdAt),
    );
    return msgs;
  }
}
