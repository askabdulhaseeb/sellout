// ignore_for_file: always_specify_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../features/personal/chats/chat/data/models/message_last_evaluated_key.dart';
import '../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../functions/app_log.dart';

class SocketImplementations {
  // NEW MESSAGES
  Future<void> handleNewMessage(Map<String, dynamic> data) async {
    final MessageModel newMsg = MessageModel.fromJson(data);
    final String chatId = data['chat_id'];
    // Get existing entity from local storage
    // final GettedMessageEntity? existingEntity = LocalChatMessage().entity(chatId);
    final List<MessageEntity> existingMessages =
        LocalChatMessage().messages(chatId);

    // 🔒 Check if the message already exists
    final bool isDuplicate = existingMessages.any(
      (MessageEntity m) => m.messageId == newMsg.messageId,
    );

    if (!isDuplicate) {
      existingMessages.add(newMsg);
    }

    // Create updated entity
    final GettedMessageEntity updatedEntity = GettedMessageEntity(
      chatID: chatId,
      messages: existingMessages,
      lastEvaluatedKey: MessageLastEvaluatedKeyModel(
        chatID: chatId,
        createdAt: data['created_at'],
        paginationKey: data['message_id'],
      ),
    );

    // Save updated entity to local storage
    LocalChatMessage().save(updatedEntity, chatId);
    await LocalUnreadMessagesService().increment(chatId);
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

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // Future<void> showLocalNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'Your Channel Name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //   );
  // }
}
