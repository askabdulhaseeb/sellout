import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../features/personal/bookings/data/sources/local_booking.dart';
import '../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../features/personal/notifications/data/models/notification_model.dart';
import '../../features/personal/notifications/data/source/local/local_notification.dart';
import '../functions/app_log.dart';  
import 'socket_implementations.dart'; 

class SocketService with WidgetsBindingObserver {
  SocketService(this._socketImplementations);
  final SocketImplementations _socketImplementations;
  io.Socket? socket;
  bool _isInitialized = false;
  bool get isConnected => socket?.connected ?? false;
  void initAndListen() {
    if (_isInitialized) return;
    _isInitialized = true;
    WidgetsBinding.instance.addObserver(this);
    LocalAuth.uidNotifier.addListener(() {
      final String? uid = LocalAuth.uidNotifier.value;
      if (uid != null) {
        AppLog.info('🔓 UID set. Connecting socket...', name: 'socket');
        connect();
      } else {
        AppLog.info('🔒 UID is null. Disconnecting socket...', name: 'socket');
        disconnect();
      }
    });
    if (LocalAuth.uid != null) {
      connect();
    } else {
      AppLog.info('🔒 No UID at startup. Socket will not connect.',
          name: 'socket');
    }
  }
  void connect() {
    final String? baseUrl = dotenv.env['baseURL'];
    final String? entityId = LocalAuth.uid;
    if (baseUrl == null || entityId == null) {
      AppLog.error('Missing baseURL or userId (entityId)',
          name: 'SocketService.connect');
      return;
    }
    if (socket != null && socket!.connected) return;

    socket!.connect();
    socket!.onConnect((_) {
      AppLog.info('✅ Connected to server: ${socket!.id}');
    });
    socket!.onConnectError((dynamic data) {
      AppLog.error('🚨 Connect error: $data');
    });
    socket!.onDisconnect((_) {
      AppLog.error(' Disconnected from server');
    });
    socket!.onDisconnect((_) {
      AppLog.error(' Disconnected from server',
          name: 'SocketService.disconnect');
    });
    socket!.on('getOnlineUsers', (dynamic data) async {
      AppLog.info('📶 Online users: $data',
          name: 'SocketService.getOnlineUsers');
      // Since `data` is already a list of strings, you can directly use it
      List<String> onlineUsers = List<String>.from(data);
      await _socketImplementations.handleOnlineUsers(onlineUsers);
      debugPrint('Updated online users list: $onlineUsers');
    });

    socket!.on('new-notification', (dynamic data) async {
      AppLog.info('🔔 New notification: $data',
          name: 'SocketService.new-notification');
      if (data['metadata'] != null && data['metadata']['booking_id'] != null) {
        final Map<String, dynamic> metadata =
            Map<String, dynamic>.from(data['metadata']);
        await LocalBooking().update(metadata['booking_id'], metadata);
      }
      LocalNotifications.saveNotification(NotificationModel.fromMap(data));
    });

    socket!.on('lastSeen', (dynamic data) {
      AppLog.info('🕓 Last seen: $data', name: 'SocketService.lastSeen');
    });

    socket!.on('newMessage', (dynamic data) async {
      AppLog.info('📨 New message received: $data',
          name: 'SocketService.newMessage');
      await LocalChatMessage().saveMessage(MessageModel.fromMap(data));
    });

    socket!.on('updatedMessage', (dynamic data) async {
      AppLog.info('📝 Message update arrived: $data',
          name: 'SocketService.updatedMessage');
      await LocalChatMessage().saveMessage(MessageModel.fromMap(data));
    });

    socket!.on('update-pinned-message', (dynamic data) async {
      AppLog.info('📝 Updated Pinned Message  arrived: $data',
          name: 'SocketService.updatedPinnedMessage');
      await LocalChat().updatePinnedMessage(MessageModel.fromMap(data));
    });

    socket!.on('new-pinned-message', (dynamic data) async {
      AppLog.info('📝 New Pinned Message arrived: $data',
          name: 'SocketService.newPinnedMessage');
      await LocalChat().updatePinnedMessage(MessageModel.fromMap(data));
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
