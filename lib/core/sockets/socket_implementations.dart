import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../features/personal/chats/chat/data/models/message_last_evaluated_key.dart';
import '../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../functions/app_log.dart';

class SocketImplementations {
  // NEW MESSAGES
  Future<void> handleNewMessage(Map<String, dynamic> data) async {
    final MessageModel newMsg = MessageModel.fromJson(data);
    final String chatId = data['chat_id'];
    final Box<GettedMessageEntity> messageBox =
        Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
    final bool exists = messageBox.containsKey(chatId);
    if (!exists) {
      final GetMyChatsUsecase getMyChatUsecase = GetMyChatsUsecase(locator());
      final DataState<List<ChatEntity>> chatResult =
          await getMyChatUsecase.call(<String>[chatId]);
      if (chatResult is DataSuccess &&
          (chatResult.entity?.isNotEmpty ?? false)) {
        final ChatEntity newChat = chatResult.entity!.first;
        final Box<ChatEntity> localChatsBox =
            Hive.box<ChatEntity>(AppStrings.localChatsBox);
        await localChatsBox.put(chatId, newChat);
      }
    }

    final GettedMessageEntity existing = messageBox.get(chatId) ??
        GettedMessageEntity(
          chatID: chatId,
          messages: <MessageModel>[],
          lastEvaluatedKey: MessageLastEvaluatedKeyModel(
            chatID: chatId,
            createdAt: data['created_at'],
            paginationKey: data['message_id'],
          ),
        );
    existing.messages.add(newMsg);
    await messageBox.put(chatId, existing);
  }

  // UPDATE MESSAGES
  Future<void> handleUpdatedMessage(Map<String, dynamic> data) async {
    final Map<String, dynamic> messageData = data;
    final String? chatId = messageData['chat_id'];
    final String? updatedMessageId = messageData['message_id'];

    if (chatId == null || updatedMessageId == null) {
      AppLog.error('Missing chatId or updatedMessageId in the data.');
      return;
    }

    final Box<GettedMessageEntity> box =
        Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
    final GettedMessageEntity? existing = box.get(chatId);

    if (existing == null) {
      AppLog.error('No existing messages found for chatId: $chatId');
      return;
    }

    final int index = existing.messages.indexWhere(
      (MessageEntity m) => m.messageId == updatedMessageId,
    );

    if (index == -1) {
      AppLog.error(
          'Message with messageId: $updatedMessageId not found in chatId: $chatId');
      return;
    }

    try {
      final List<MessageEntity> updatedMessages =
          List<MessageEntity>.from(existing.messages);
      updatedMessages[index] = MessageModel.fromJson(messageData);
      final GettedMessageEntity updatedEntity = GettedMessageEntity(
          chatID: existing.chatID,
          messages: updatedMessages,
          lastEvaluatedKey: existing.lastEvaluatedKey);

      await box.put(chatId, updatedEntity);
      AppLog.info('Successfully updated messages in Hive for chatId: $chatId');
    } catch (e, stackTrace) {
      AppLog.error('Error saving updated messages to Hive: $e',
          stackTrace: stackTrace, name: 'SocketService.updatedMessage');
    }
  }

  // ONLINE USERS
  final ValueNotifier<List<String>> onlineUsers = ValueNotifier(<String>[]);

  Future<void> handleOnlineUsers(List<String> users) async {
    onlineUsers.value = users;
    debugPrint(onlineUsers.value.toString());
  }
}
