import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../features/personal/chats/chat/data/models/message_last_evaluated_key.dart';
import '../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
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
    socket!.on('updatedMessage', (dynamic data) {
      AppLog.info('message update arrived: $data',
          name: 'SocketService.updatedMessage');
      final Map<String, dynamic> messageData = data;
      final String chatId = messageData['chat_id'];
      final String updatedMessageId = messageData['message_id'];

      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);

      final GettedMessageEntity? existing = box.get(chatId);
      if (existing == null) return;

      final int index = existing.messages.indexWhere(
        (MessageEntity m) => m.messageId == updatedMessageId,
      );

      if (index == -1) return;

      existing.messages[index] = MessageModel.fromJson(messageData);
      box.put(chatId, existing);
    });

    socket!.on('newMessage', (dynamic data) async {
      AppLog.info('📨 New message received: $data',
          name: 'SocketService.newMessage');

      final Map<String, dynamic> messageData = data;
      final MessageModel newMsg = MessageModel.fromJson(messageData);
      final String chatId = messageData['chat_id'];

      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);

      final GettedMessageEntity existing =
          box.values.firstWhere((GettedMessageEntity e) => e.chatID == chatId,
              orElse: () => GettedMessageEntity(
                    chatID: chatId,
                    messages: <MessageModel>[],
                    lastEvaluatedKey: MessageLastEvaluatedKeyModel(
                        chatID: data['chat_id'],
                        createdAt: data['created_at'],
                        paginationKey: data['message_id']),
                  ));

      existing.messages.add(newMsg);

      if (box.containsKey(existing.chatID)) {
        await box.put(existing.chatID, existing);
      } else {
        await box.add(existing);
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
