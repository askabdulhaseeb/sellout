// ignore_for_file: always_specify_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../features/personal/chats/chat/data/models/message_last_evaluated_key.dart';
import '../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../features/personal/chats/chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../features/personal/payment/data/models/wallet_model.dart';
import '../../features/personal/payment/data/sources/local/local_wallet.dart';
import '../../services/get_it.dart';
import '../functions/app_log.dart';
import '../sources/api_call.dart';

class SocketImplementations {
  // WALLET UPDATED
  Future<void> handleWalletUpdated(dynamic data) async {
    try {
      // Parse wallet data and save locally
      if (data is Map<String, dynamic>) {
        final wallet = WalletModel.fromJson(data);
        await LocalWallet().saveWallet(wallet);
        AppLog.info('Wallet updated and saved locally.');
      } else {
        AppLog.error('Wallet update data is not a Map<String, dynamic>.');
      }
    } catch (e) {
      AppLog.error('Error in handleWalletUpdated: $e');
    }
  }

  // NEW MESSAGES
  Future<void> handleNewMessage(Map<String, dynamic> data) async {
    final MessageModel newMsg = MessageModel.fromMap(data);
    final String chatId = data['chat_id'];

    //  Fetch existing chat messages
    final List<MessageEntity> existingMessages = LocalChatMessage().messages(
      chatId,
    );

    //  Check for duplicates
    final bool isDuplicate = existingMessages.any(
      (MessageEntity m) => m.messageId == newMsg.messageId,
    );

    if (!isDuplicate) {
      existingMessages.add(newMsg);
    }

    //  Ensure chat exists locally
    ChatEntity? localChat = LocalChat().chatEntity(chatId);
    if (localChat == null) {
      final getMyChats = GetMyChatsUsecase(locator());
      final result = await getMyChats.call([chatId]);

      if (result is DataSuccess<List<ChatEntity>>) {
        final fetchedChat = result.entity?.firstWhere(
          (ChatEntity chat) => chat.chatId == chatId,
        );
        if (fetchedChat != null) {
          LocalChat().save(fetchedChat.chatId, fetchedChat);
          localChat = fetchedChat;
        }
      } else {
        AppLog.error(
          ' Failed to fetch chat from server | chatId: $chatId',
          name: 'SocketImpl.handleNewMessage',
        );
      }
    }

    // 💾 Save to local message store
    final GettedMessageEntity updatedEntity = GettedMessageEntity(
      chatID: chatId,
      messages: existingMessages,
      lastEvaluatedKey: MessageLastEvaluatedKeyModel(
        chatID: chatId,
        createdAt: data['created_at'],
        paginationKey: data['message_id'],
      ),
    );
    LocalChatMessage().saveGettedMessageEntity(updatedEntity, chatId);

    // ✅ Update local chat lastMessage
    if (localChat != null) {
      final updatedChat = localChat.copyWith(lastMessage: newMsg);
      LocalChat().save(updatedChat.chatId, updatedChat);
    }

    //  Unread count
    await LocalUnreadMessagesService().increment(chatId);

    //  Final Log
    AppLog.info(
      '🟢 New message saved | chatId: $chatId | messageId: ${newMsg.messageId}',
      name: 'SocketImpl.handleNewMessage',
    );
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

    final Box<GettedMessageEntity> box = Hive.box<GettedMessageEntity>(
      AppStrings.localChatMessagesBox,
    );
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
        'Message with messageId: $updatedMessageId not found in chatId: $chatId',
      );
      return;
    }

    try {
      final List<MessageEntity> updatedMessages = List<MessageEntity>.from(
        existing.messages,
      );
      updatedMessages[index] = MessageModel.fromMap(messageData);
      final GettedMessageEntity updatedEntity = GettedMessageEntity(
        chatID: existing.chatID,
        messages: updatedMessages,
        lastEvaluatedKey: existing.lastEvaluatedKey,
      );

      await box.put(chatId, updatedEntity);
      AppLog.info('Successfully updated messages in Hive for chatId: $chatId');
    } catch (e, stackTrace) {
      AppLog.error(
        'Error saving updated messages to Hive: $e',
        stackTrace: stackTrace,
        name: 'SocketService.updatedMessage',
      );
    }
  }

  // ONLINE USERS
  final ValueNotifier<List<String>> onlineUsers = ValueNotifier(<String>[]);
  final ValueNotifier<Map<String, String>> lastSeenMap = ValueNotifier(
    <String, String>{},
  );

  Future<void> handleOnlineUsers(List<String> users) async {
    onlineUsers.value = users;
    debugPrint('Online users: ${onlineUsers.value}');
  }

  void handleUserOnline(String entityId) {
    final List<String> currentUsers = List<String>.from(onlineUsers.value);
    if (!currentUsers.contains(entityId)) {
      currentUsers.add(entityId);
      onlineUsers.value = currentUsers;
    }
    // Remove from last seen map when user comes online
    final Map<String, String> currentLastSeen = Map<String, String>.from(
      lastSeenMap.value,
    );
    currentLastSeen.remove(entityId);
    lastSeenMap.value = currentLastSeen;
    debugPrint(
      'User online: $entityId | Total online: ${onlineUsers.value.length}',
    );
  }

  void handleUserOffline(String entityId, String lastSeen) {
    final List<String> currentUsers = List<String>.from(onlineUsers.value);
    currentUsers.remove(entityId);
    onlineUsers.value = currentUsers;
    // Add to last seen map
    if (lastSeen.isNotEmpty) {
      final Map<String, String> currentLastSeen = Map<String, String>.from(
        lastSeenMap.value,
      );
      currentLastSeen[entityId] = lastSeen;
      lastSeenMap.value = currentLastSeen;
    }
    debugPrint(
      'User offline: $entityId at $lastSeen | Total online: ${onlineUsers.value.length}',
    );
  }

  // Notifictions
  //   Future<void> handleNotification(Map<String, dynamic> data) async {}
}
