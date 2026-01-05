import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sockets/handlers/base_socket_handler.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../chat/data/models/message_last_evaluated_key.dart';
import '../../../../chat/data/sources/local/local_message.dart';
import '../../../../chat/domain/entities/getted_message_entity.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import '../../../domain/entities/messages/message_entity.dart';
import '../../../domain/usecase/get_my_chats_usecase.dart';
import '../../models/message/message_model.dart';
import '../local/local_chat.dart';
import '../local/local_unseen_messages.dart';

/// Upload progress data for a message.
class UploadProgressData {
  UploadProgressData({
    required this.messageId,
    required this.progress,
    this.chatId,
    this.status,
  });

  final String messageId;
  final double progress; // 0.0 to 1.0
  final String? chatId;
  final String? status; // 'uploading', 'completed', 'failed'

  bool get isCompleted => progress >= 1.0 || status == 'completed';
  bool get isFailed => status == 'failed';
}

/// Handles chat-related socket events (messages, pinned messages, upload progress).
class ChatSocketHandler extends BaseSocketHandler {
  /// Notifier for upload progress updates.
  /// Maps messageId -> UploadProgressData for tracking multiple uploads.
  final ValueNotifier<Map<String, UploadProgressData>> uploadProgressNotifier =
      ValueNotifier<Map<String, UploadProgressData>>(<String, UploadProgressData>{});

  @override
  List<String> get supportedEvents => <String>[
        AppStrings.newMessage,
        AppStrings.updatedMessage,
        AppStrings.newPinnedMessage,
        AppStrings.updatePinnedMessage,
        AppStrings.uploadProgress,
      ];

  @override
  Future<void> handleEvent(String eventName, dynamic data) async {
    if (data == null) return;

    switch (eventName) {
      case 'newMessage':
        await _handleNewMessage(data);
        break;
      case 'updatedMessage':
        await _handleUpdatedMessage(data);
        break;
      case 'newPinnedMessage':
      case 'new-pinned-message':
        await _handlePinnedMessage(data);
        break;
      case 'updatePinnedMessage':
      case 'update-pinned-message':
        await _handlePinnedMessage(data);
        break;
      case 'uploadProgress':
        _handleUploadProgress(data);
        break;
    }
  }

  Future<void> _handleNewMessage(dynamic data) async {
    try {
      if (data is! Map<String, dynamic>) return;

      final MessageModel newMsg = MessageModel.fromMap(data);
      // Use chatId from parsed model (handles null safely) instead of raw data
      final String chatId = newMsg.chatId;

      if (chatId.isEmpty) {
        AppLog.error(
          'Missing chat_id in newMessage data: $data',
          name: 'ChatSocketHandler',
        );
        return;
      }

      // Fetch existing chat messages
      final List<MessageEntity> existingMessages = LocalChatMessage().messages(
        chatId,
      );

      // Check for duplicates
      final bool isDuplicate = existingMessages.any(
        (MessageEntity m) => m.messageId == newMsg.messageId,
      );

      if (!isDuplicate) {
        existingMessages.add(newMsg);
      }

      // Ensure chat exists locally
      ChatEntity? localChat = LocalChat().chatEntity(chatId);
      if (localChat == null) {
        final GetMyChatsUsecase getMyChats = GetMyChatsUsecase(locator());
        final dynamic result = await getMyChats.call(<String>[chatId]);

        if (result is DataSuccess<List<ChatEntity>>) {
          final ChatEntity? fetchedChat = result.entity?.firstWhere(
            (ChatEntity chat) => chat.chatId == chatId,
          );
          if (fetchedChat != null) {
            LocalChat().save(fetchedChat.chatId, fetchedChat);
            localChat = fetchedChat;
          }
        } else {
          AppLog.error(
            'Failed to fetch chat from server | chatId: $chatId',
            name: 'ChatSocketHandler.handleNewMessage',
          );
        }
      }

      // Save to local message store
      final GettedMessageEntity updatedEntity = GettedMessageEntity(
        chatID: chatId,
        messages: existingMessages,
        lastEvaluatedKey: MessageLastEvaluatedKeyModel(
          chatID: chatId,
          createdAt: data['created_at']?.toString() ?? newMsg.createdAt.toIso8601String(),
          paginationKey: data['message_id']?.toString() ?? newMsg.messageId,
        ),
      );
      LocalChatMessage().saveGettedMessageEntity(updatedEntity, chatId);

      // Update local chat lastMessage
      if (localChat != null) {
        final ChatEntity updatedChat = localChat.copyWith(lastMessage: newMsg);
        LocalChat().save(updatedChat.chatId, updatedChat);
      }

      // Unread count
      await LocalUnreadMessagesService().increment(chatId);

      AppLog.info(
        'New message saved | chatId: $chatId | messageId: ${newMsg.messageId}',
        name: 'ChatSocketHandler',
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'Error saving new message: $e',
        stackTrace: stackTrace,
        name: 'ChatSocketHandler',
      );
    }
  }

  Future<void> _handleUpdatedMessage(dynamic data) async {
    try {
      if (data is! Map<String, dynamic>) return;

      final String? chatId = data['chat_id'];
      final String? updatedMessageId = data['message_id'];

      if (chatId == null || updatedMessageId == null) {
        AppLog.error(
          'Missing chatId or updatedMessageId in the data.',
          name: 'ChatSocketHandler',
        );
        return;
      }

      final Box<GettedMessageEntity> box = Hive.box<GettedMessageEntity>(
        AppStrings.localChatMessagesBox,
      );
      final GettedMessageEntity? existing = box.get(chatId);

      if (existing == null) {
        AppLog.error(
          'No existing messages found for chatId: $chatId',
          name: 'ChatSocketHandler',
        );
        return;
      }

      final int index = existing.messages.indexWhere(
        (MessageEntity m) => m.messageId == updatedMessageId,
      );

      if (index == -1) {
        AppLog.error(
          'Message with messageId: $updatedMessageId not found in chatId: $chatId',
          name: 'ChatSocketHandler',
        );
        return;
      }

      final List<MessageEntity> updatedMessages = List<MessageEntity>.from(
        existing.messages,
      );
      updatedMessages[index] = MessageModel.fromMap(data);

      final GettedMessageEntity updatedEntity = GettedMessageEntity(
        chatID: existing.chatID,
        messages: updatedMessages,
        lastEvaluatedKey: existing.lastEvaluatedKey,
      );

      await box.put(chatId, updatedEntity);
      AppLog.info(
        'Message updated | chatId: $chatId | messageId: $updatedMessageId',
        name: 'ChatSocketHandler',
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'Error updating message: $e',
        stackTrace: stackTrace,
        name: 'ChatSocketHandler',
      );
    }
  }

  Future<void> _handlePinnedMessage(dynamic data) async {
    try {
      if (data is Map<String, dynamic>) {
        await LocalChat().updatePinnedMessage(MessageModel.fromMap(data));
        AppLog.info('Pinned message updated', name: 'ChatSocketHandler');
      }
    } catch (e) {
      AppLog.error('Error updating pinned message: $e', name: 'ChatSocketHandler');
    }
  }

  void _handleUploadProgress(dynamic data) {
    try {
      if (data is! Map<String, dynamic>) return;

      final String? messageId = data['message_id']?.toString();
      if (messageId == null) {
        AppLog.error(
          'Missing message_id in uploadProgress data',
          name: 'ChatSocketHandler',
        );
        return;
      }

      final double progress = (data['progress'] as num?)?.toDouble() ?? 0.0;
      final String? chatId = data['chat_id']?.toString();
      final String? status = data['status']?.toString();

      final UploadProgressData progressData = UploadProgressData(
        messageId: messageId,
        progress: progress,
        chatId: chatId,
        status: status,
      );

      // Update the notifier with new progress data
      final Map<String, UploadProgressData> currentMap =
          Map<String, UploadProgressData>.from(uploadProgressNotifier.value);
      currentMap[messageId] = progressData;
      uploadProgressNotifier.value = currentMap;

      AppLog.info(
        'Upload progress | messageId: $messageId | progress: ${(progress * 100).toStringAsFixed(1)}%',
        name: 'ChatSocketHandler',
      );

      // Clean up completed/failed uploads after a delay
      if (progressData.isCompleted || progressData.isFailed) {
        Future<void>.delayed(const Duration(seconds: 2), () {
          final Map<String, UploadProgressData> cleanedMap =
              Map<String, UploadProgressData>.from(uploadProgressNotifier.value);
          cleanedMap.remove(messageId);
          uploadProgressNotifier.value = cleanedMap;
        });
      }
    } catch (e) {
      AppLog.error('Error handling upload progress: $e', name: 'ChatSocketHandler');
    }
  }

  /// Get upload progress for a specific message.
  UploadProgressData? getUploadProgress(String messageId) {
    return uploadProgressNotifier.value[messageId];
  }

  /// Clear upload progress for a specific message.
  void clearUploadProgress(String messageId) {
    final Map<String, UploadProgressData> currentMap =
        Map<String, UploadProgressData>.from(uploadProgressNotifier.value);
    currentMap.remove(messageId);
    uploadProgressNotifier.value = currentMap;
  }

  @override
  void dispose() {
    uploadProgressNotifier.dispose();
  }
}
