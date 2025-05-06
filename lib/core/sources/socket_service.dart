import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../features/personal/chats/chat/domain/entities/message_last_evaluated_key_entity.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../functions/app_log.dart';
import '../utilities/app_string.dart';

class SocketService {
  factory SocketService() => _instance;
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();

  IO.Socket? socket;

  bool get isConnected => socket?.connected ?? false;

  void connect() {
    final String? baseUrl = dotenv.env['baseURL'];
    final String? entityId = LocalAuth.uid;

    if (baseUrl == null || entityId == null) {
      AppLog.error('Missing baseURL or userId (entityId)',
          name: 'SocketService.connect');
      return;
    }

    // Avoid reconnecting if already connected
    if (socket != null && socket!.connected) {
      AppLog.info('Socket already connected', name: 'SocketService.connect');
      return;
    }
    // Connect
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
      'query': <String, String>{'entity_id': entityId},
      'withCredentials': true,
    });

    socket!.connect();
    socket!.onConnect((_) {
      AppLog.info('✅ Connected to server: ${socket!.id}',
          name: 'SocketService.connect');
      debugPrint('🔐 Auth info: ${socket!.auth}');
    });

    socket!.onConnectError((dynamic data) {
      AppLog.error('🚨 Connect error: $data',
          name: 'SocketService.connectError');
    });

    socket!.onDisconnect((_) {
      AppLog.error('❌ Disconnected from server',
          name: 'SocketService.disconnect');
    });

    socket!.on('getOnlineUsers', (dynamic data) {
      AppLog.info('📶 Online users: $data',
          name: 'SocketService.getOnlineUsers');
    });

    socket!.on('lastSeen', (dynamic data) {
      AppLog.info('🕓 Last seen: $data', name: 'SocketService.lastSeen');
    });

    socket!.on('newMessage', (dynamic data) {
      AppLog.info('📨 New message received: $data',
          name: 'SocketService.newMessage');

      final Map<String, dynamic> messageData = data;
      AppLog.info('Decoded message data: $messageData',
          name: 'SocketService.newMessage');

      // Create a new MessageModel from the decoded data
      final MessageModel newMsg = MessageModel.fromJson(messageData);
      AppLog.info('Created new message: $newMsg',
          name: 'SocketService.newMessage');

      // Extract the chat ID from the message data
      final String chatId = messageData['chat_id'];
      AppLog.info('Chat ID extracted: $chatId',
          name: 'SocketService.newMessage');

      // Open the Hive box to store the messages
      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
      AppLog.info('Opened Hive box: ${AppStrings.localChatMessagesBox}',
          name: 'SocketService.newMessage');

      // Check if the chatId exists in the box
      final GettedMessageEntity existing = box.values.firstWhere(
        (GettedMessageEntity e) => e.chatID == chatId,
        orElse: () => GettedMessageEntity(
          chatID: chatId,
          messages: <MessageModel>[],
          lastEvaluatedKey: MessageLastEvaluatedKeyEntity(
            chatID: chatId,
            createdAt: messageData['created_at'],
            paginationKey: messageData['message_id'],
          ),
        ),
      );
      AppLog.info('Existing message entity found for chatId: $chatId',
          name: 'SocketService.newMessage');

      // Log the current state of messages in the entity
      AppLog.info(
          'Current messages in chatID $chatId: ${existing.messages.length}',
          name: 'SocketService.newMessage');

      // Add the new message to the list
      existing.messages.add(newMsg);
      AppLog.info(
          'New message added to chatID $chatId. Total messages: ${existing.messages.length}',
          name: 'SocketService.newMessage');

      // Check if the chatId exists in the box, then either update or add
      if (box.containsKey(existing.chatID)) {
        box.put(existing.chatID, existing);
        AppLog.info('Updated existing chat ID $chatId in the Hive box',
            name: 'SocketService.newMessage');
      } else {
        box.add(existing);
        AppLog.info('Added new chat ID $chatId to the Hive box',
            name: 'SocketService.newMessage');
      }
    });

    socket!.onAny((String event, dynamic data) {
      debugPrint('📡 Event: $event');
      debugPrint('📦 Data: $data');
    });

    socket!.onAnyOutgoing((String event, dynamic data) {
      AppLog.info('📤 Outgoing: $event → $data',
          name: 'SocketService.outgoing');
    });
  }

  void disconnect() {
    socket?.disconnect();
    AppLog.info('⚠️ Manual disconnect', name: 'SocketService.disconnect');
  }
}
