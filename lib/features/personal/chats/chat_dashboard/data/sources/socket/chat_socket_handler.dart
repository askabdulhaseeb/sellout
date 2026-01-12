import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sockets/handlers/base_socket_handler.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
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

  /// Notifier for read receipts - emits (chatId, userId, lastReadMessageId).
  final ValueNotifier<Map<String, Map<String, String>>> readReceiptsNotifier =
      ValueNotifier<Map<String, Map<String, String>>>(<String, Map<String, String>>{});

  @override
  List<String> get supportedEvents => <String>[
        AppStrings.newMessage,
        AppStrings.updatedMessage,
        AppStrings.newPinnedMessage,
        AppStrings.updatePinnedMessage,
        AppStrings.uploadProgress,
        AppStrings.messagesRead,
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
      case 'messagesRead':
        _handleMessagesRead(data);
        break;
    }
  }

  Future<void> _handleNewMessage(dynamic data) async {
    try {
      if (data is! Map<String, dynamic>) return;

      final MessageModel newMsg = MessageModel.fromMap(data);
      // Use chatId from parsed model (handles null safely) instead of raw data
      String chatId = newMsg.chatId;

      // If chat_id is missing but message_id exists, this might be a partial update
      // (server sometimes sends file upload completion as newMessage with only updated fields)
      if (chatId.isEmpty && newMsg.messageId.isNotEmpty) {
        AppLog.info(
          'newMessage missing chat_id, treating as update | messageId: ${newMsg.messageId}',
          name: 'ChatSocketHandler',
        );
        await _handlePartialUpdate(data, newMsg.messageId);
        return;
      }

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

  /// Handles partial message updates (e.g., file upload completion sent as newMessage
  /// with only the updated fields like file_url, file_status, but missing chat_id).
  /// Finds the existing message by messageId and merges the updated fields.
  Future<void> _handlePartialUpdate(
    Map<String, dynamic> data,
    String messageId,
  ) async {
    try {
      final Box<GettedMessageEntity> box = Hive.box<GettedMessageEntity>(
        AppStrings.localChatMessagesBox,
      );

      // Search all chats for the message with this ID
      for (final GettedMessageEntity entity in box.values) {
        final int index = entity.messages.indexWhere(
          (MessageEntity m) => m.messageId == messageId,
        );

        if (index != -1) {
          final MessageEntity existingMsg = entity.messages[index];

          // Merge the partial update with existing message data
          final Map<String, dynamic> mergedData = <String, dynamic>{
            'message_id': existingMsg.messageId,
            'chat_id': existingMsg.chatId,
            'send_by': existingMsg.sendBy,
            'persons': existingMsg.persons,
            'text': existingMsg.text,
            'display_text': data['display_text'] ?? existingMsg.displayText,
            'type': existingMsg.type?.code,
            'source': existingMsg.source,
            'created_at': existingMsg.createdAt.toIso8601String(),
            'updated_at': data['updated_at'] ??
                existingMsg.updatedAt.toIso8601String(),
            'file_status': data['file_status'] ?? existingMsg.fileStatus,
            'file_url': data['file_url'] ??
                existingMsg.fileUrl
                    .map((AttachmentEntity f) => <String, dynamic>{
                          'url': f.url,
                          'type': f.type.json,
                          'original_name': f.originalName,
                          'file_id': f.fileId,
                          'created_at': f.createdAt.toIso8601String(),
                        })
                    .toList(),
          };

          final MessageModel updatedMsg = MessageModel.fromMap(mergedData);

          final List<MessageEntity> updatedMessages = List<MessageEntity>.from(
            entity.messages,
          );
          updatedMessages[index] = updatedMsg;

          final GettedMessageEntity updatedEntity = GettedMessageEntity(
            chatID: entity.chatID,
            messages: updatedMessages,
            lastEvaluatedKey: entity.lastEvaluatedKey,
          );

          await box.put(entity.chatID, updatedEntity);
          AppLog.info(
            'Partial update applied | chatId: ${entity.chatID} | messageId: $messageId',
            name: 'ChatSocketHandler',
          );
          return;
        }
      }

      AppLog.error(
        'Message not found for partial update | messageId: $messageId',
        name: 'ChatSocketHandler',
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'Error handling partial update: $e',
        stackTrace: stackTrace,
        name: 'ChatSocketHandler',
      );
    }
  }

  Future<void> _handleUpdatedMessage(dynamic data) async {
    try {
      if (data is! Map<String, dynamic>) return;

      final MessageModel updatedMsg = MessageModel.fromMap(data);
      // Use chatId from parsed model (handles null safely)
      final String chatId = updatedMsg.chatId;
      final String updatedMessageId = updatedMsg.messageId;

      if (chatId.isEmpty || updatedMessageId.isEmpty) {
        AppLog.error(
          'Missing chatId or messageId in updatedMessage data: $data',
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
        // Message not found locally - add it as a new message
        AppLog.info(
          'Message not found locally, adding as new | chatId: $chatId | messageId: $updatedMessageId',
          name: 'ChatSocketHandler',
        );
        final List<MessageEntity> messagesWithNew = List<MessageEntity>.from(
          existing.messages,
        )..add(updatedMsg);

        final GettedMessageEntity entityWithNew = GettedMessageEntity(
          chatID: existing.chatID,
          messages: messagesWithNew,
          lastEvaluatedKey: existing.lastEvaluatedKey,
        );
        await box.put(chatId, entityWithNew);
        return;
      }

      final List<MessageEntity> updatedMessages = List<MessageEntity>.from(
        existing.messages,
      );
      updatedMessages[index] = updatedMsg;

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

  // ============ Read Receipt Handlers ============

  void _handleMessagesRead(dynamic data) async {
    try {
      if (data is! Map<String, dynamic>) return;

      final String? chatId = data['chat_id']?.toString();
      final String? userId = data['user_id']?.toString();
      final String? lastReadMessageId = data['last_read_message_id']?.toString();

      if (chatId == null || userId == null) {
        AppLog.error(
          'Missing chat_id or user_id in messagesRead data',
          name: 'ChatSocketHandler',
        );
        return;
      }

      final Map<String, Map<String, String>> currentMap =
          Map<String, Map<String, String>>.from(readReceiptsNotifier.value);

      final Map<String, String> chatReadReceipts =
          Map<String, String>.from(currentMap[chatId] ?? <String, String>{});

      if (lastReadMessageId != null) {
        chatReadReceipts[userId] = lastReadMessageId;
      }

      currentMap[chatId] = chatReadReceipts;
      readReceiptsNotifier.value = currentMap;

      // Update local message status to 'read' for messages sent by current user
      // This happens when the other user reads our messages
      final String? currentUserId = LocalAuth.uid;
      if (lastReadMessageId != null && currentUserId != null && userId != currentUserId) {
        await LocalChatMessage().markMessagesAsRead(
          chatId,
          lastReadMessageId,
          currentUserId,
        );
      }

      AppLog.info(
        'Messages read | chatId: $chatId | userId: $userId | lastRead: $lastReadMessageId',
        name: 'ChatSocketHandler',
      );
    } catch (e) {
      AppLog.error('Error handling messagesRead: $e', name: 'ChatSocketHandler');
    }
  }

  /// Get the last read message ID for a user in a chat.
  String? getLastReadMessageId(String chatId, String userId) {
    return readReceiptsNotifier.value[chatId]?[userId];
  }

  /// Get all read receipts for a chat.
  Map<String, String> getChatReadReceipts(String chatId) {
    return readReceiptsNotifier.value[chatId] ?? <String, String>{};
  }

  @override
  void dispose() {
    uploadProgressNotifier.dispose();
    readReceiptsNotifier.dispose();
  }
}
