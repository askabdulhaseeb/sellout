import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../../../core/enums/message/message_status.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';

// getOnlineUsers
class LocalChatMessage extends LocalHiveBox<GettedMessageEntity> {
  @override
  String get boxName => AppStrings.localChatMessagesBox;

  /// Chat messages contain sensitive private communications - encrypt them.
  @override
  bool get requiresEncryption => true;

  Box<GettedMessageEntity> get _box => box;

  static Future<Box<GettedMessageEntity>> get openBox async =>
      await Hive.openBox<GettedMessageEntity>(AppStrings.localChatMessagesBox);
      
  @override
  Future<Box<GettedMessageEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(AppStrings.localChatMessagesBox);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<GettedMessageEntity>(AppStrings.localChatMessagesBox);
    }
  }

  @override
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

  Future<void> saveGettedMessageEntity(
    GettedMessageEntity value,
    String chatID,
  ) async {
    final String id = value.lastEvaluatedKey?.chatID ?? chatID;
    final GettedMessageEntity? result = entity(id);
    if (result == null) {
      await _put(id, value);
      return;
    } else {
      // Create a new list to avoid mutating the original
      final List<MessageEntity> mergedMessages = List<MessageEntity>.from(
        result.messages,
      );
      final List<MessageEntity> newMessages = value.messages;
      AppLog.info(
        'New Message - old: ${mergedMessages.length} - new: ${newMessages.length}',
        name: chatID,
      );

      for (final MessageEntity newMsg in newMessages) {
        final int existingIndex = mergedMessages.indexWhere(
          (MessageEntity e) => e.messageId == newMsg.messageId,
        );
        if (existingIndex != -1) {
          // Update existing message with new data (e.g., fileStatus, fileUrl)
          mergedMessages[existingIndex] = newMsg;
        } else {
          // Add new message
          mergedMessages.add(newMsg);
        }
      }

      AppLog.info('New Message - updated: ${mergedMessages.length}', name: chatID);
      final GettedMessageEntity newGettedMessage = GettedMessageEntity(
        chatID: id,
        messages: mergedMessages,
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

  /// Mark messages as read up to (and including) the specified message ID.
  /// Updates the status of all sent messages from the current user up to lastReadMessageId.
  Future<void> markMessagesAsRead(
    String chatId,
    String lastReadMessageId,
    String currentUserId,
  ) async {
    final GettedMessageEntity? entity = _box.get(chatId);
    if (entity == null) return;

    final List<MessageEntity> updatedMessages = <MessageEntity>[];
    bool foundLastRead = false;

    // Messages are sorted newest first, so we process in reverse
    final List<MessageEntity> sortedMessages = List<MessageEntity>.from(
      entity.messages,
    )..sort(
        (MessageEntity a, MessageEntity b) => a.createdAt.compareTo(b.createdAt),
      );

    for (final MessageEntity msg in sortedMessages) {
      // Only update messages sent by current user that are delivered (not already read)
      final bool isFromCurrentUser = msg.sendBy == currentUserId;
      final bool isDeliveredOrSent = msg.status == MessageStatus.sent ||
          msg.status == MessageStatus.delivered;

      if (isFromCurrentUser && isDeliveredOrSent && !foundLastRead) {
        // Update status to read
        updatedMessages.add(msg.copyWith(
          status: MessageStatus.read,
        ));
      } else {
        updatedMessages.add(msg);
      }

      // Check if we've reached the last read message
      if (msg.messageId == lastReadMessageId) {
        foundLastRead = true;
      }
    }

    final GettedMessageEntity updatedEntity = entity.copyWith(
      messages: updatedMessages,
    );
    await _box.put(chatId, updatedEntity);
    AppLog.info('📖 Marked messages as read up to: $lastReadMessageId');
  }
}
