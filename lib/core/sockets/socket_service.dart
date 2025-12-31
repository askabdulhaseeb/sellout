import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../features/personal/auth/stripe/data/models/stripe_connect_account_model.dart';
import '../../features/personal/bookings/data/sources/local_booking.dart';
import '../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../features/personal/chats/chat_dashboard/data/models/message/message_model.dart';
import '../../features/personal/chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../features/personal/notifications/data/models/notification_model.dart';
import '../../features/personal/notifications/data/source/local/local_notification.dart';
import '../../services/system_notification_service.dart';
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
      AppLog.info(
        '🔒 No UID at startup. Socket will not connect.',
        name: 'socket',
      );
    }
  }

  void connect() {
    final String? baseUrl = dotenv.env['baseURL'];
    final String? entityId = LocalAuth.uid;

    if (baseUrl == null || baseUrl.isEmpty) {
      AppLog.error('Missing baseURL', name: 'SocketService.connect');
      return;
    }

    if (entityId == null || entityId.isEmpty) {
      AppLog.error('Missing userId (entityId)', name: 'SocketService.connect');
      return;
    }

    // Already connected
    if (socket != null && socket!.connected) {
      AppLog.info('Socket already connected', name: 'SocketService.connect');
      return;
    }

    // Create socket connection
    socket = io.io(baseUrl, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 2000,
      'query': <String, String>{'entity_id': entityId},
      'withCredentials': true,
    });

    if (socket == null) {
      AppLog.error('Failed to create socket', name: 'SocketService.connect');
      return;
    }

    socket!.connect();

    socket!.onConnect((_) {
      AppLog.info('✅ Connected to server: ${socket?.id ?? 'unknown'}');
    });

    socket!.onConnectError((dynamic data) {
      AppLog.error('🚨 Connect error: $data');
    });

    socket!.onDisconnect((_) {
      AppLog.error(
        'Disconnected from server',
        name: 'SocketService.disconnect',
      );
    });

    // Initial full list when connecting
    socket!.on('getOnlineUsers', (dynamic data) async {
      AppLog.info(
        '📶 Initial online users: $data',
        name: 'SocketService.getOnlineUsers',
      );
      if (data == null) return;
      try {
        final List<String> onlineUsers = List<String>.from(data);
        await _socketImplementations.handleOnlineUsers(onlineUsers);
        debugPrint('Updated online users list: $onlineUsers');
      } catch (e) {
        AppLog.error('Error parsing online users: $e');
      }
    });

    // When someone comes online
    socket!.on('userOnline', (dynamic data) {
      AppLog.info(
        '🟢 User came online: $data',
        name: 'SocketService.userOnline',
      );
      if (data == null) return;
      try {
        final String entityId = data is String ? data : data.toString();
        _socketImplementations.handleUserOnline(entityId);
      } catch (e) {
        AppLog.error('Error handling userOnline: $e');
      }
    });
    socket!.on('wallet-updated', (dynamic data) async {
      AppLog.info(
        '🟢 Wallet updated: $data',
        name: 'SocketService.walletUpdated',
      );
      if (data == null) return;
      try {
        // You may want to parse the wallet data into a WalletModel/Entity here
        // and update your local state or provider.
        await _socketImplementations.handleWalletUpdated(data);
        debugPrint('Wallet updated and local state refreshed.');
      } catch (e) {
        AppLog.error('Error handling wallet-updated: $e');
      }
    });

    socket!.on('onboarding-success', (dynamic data) async {
      AppLog.info(
        '🎉 Onboarding success: $data',
        name: 'SocketService.onboarding-success',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          final dynamic stripeData = data['stripe_connect_account'];
          if (stripeData != null && stripeData is Map<String, dynamic>) {
            final StripeConnectAccountModel account =
                StripeConnectAccountModel.fromJson(stripeData);
            await LocalAuth.updateStripeConnectAccount(account);
          }
        }
      } catch (e) {
        AppLog.error('Error handling onboarding-success: $e');
      }
    });

    // When someone goes offline
    socket!.on('userOffline', (dynamic data) {
      AppLog.info(
        '🔴 User went offline: $data',
        name: 'SocketService.userOffline',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          final String entityId = data['entityId']?.toString() ?? '';
          final String lastSeen = data['lastSeen']?.toString() ?? '';
          if (entityId.isNotEmpty) {
            _socketImplementations.handleUserOffline(entityId, lastSeen);
          }
        }
      } catch (e) {
        AppLog.error('Error handling userOffline: $e');
      }
    });

    socket!.on('new-notification', (dynamic data) async {
      AppLog.info(
        '🔔 New notification: $data',
        name: 'SocketService.new-notification',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          final dynamic metadata = data['metadata'];
          if (metadata != null &&
              metadata is Map &&
              metadata['booking_id'] != null) {
            final Map<String, dynamic> metadataMap = Map<String, dynamic>.from(
              metadata,
            );
            await LocalBooking().update(
              metadataMap['booking_id'].toString(),
              metadataMap,
            );
          }
          final NotificationModel notification = NotificationModel.fromMap(
            data,
          );
          await LocalNotifications.saveNotification(notification);

          // Show system notification
          await SystemNotificationService().showNotification(notification);
        }
      } catch (e) {
        AppLog.error('Error handling notification: $e');
      }
    });

    socket!.on('lastSeen', (dynamic data) {
      AppLog.info('🕓 Last seen: $data', name: 'SocketService.lastSeen');
    });

    socket!.on('newMessage', (dynamic data) async {
      AppLog.info(
        '📨 New message received: $data',
        name: 'SocketService.newMessage',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          await LocalChatMessage().saveMessage(MessageModel.fromMap(data));
        }
      } catch (e) {
        AppLog.error('Error saving new message: $e');
      }
    });

    socket!.on('updatedMessage', (dynamic data) async {
      AppLog.info(
        '📝 Message update arrived: $data',
        name: 'SocketService.updatedMessage',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          await LocalChatMessage().saveMessage(MessageModel.fromMap(data));
        }
      } catch (e) {
        AppLog.error('Error updating message: $e');
      }
    });

    socket!.on('update-pinned-message', (dynamic data) async {
      AppLog.info(
        '📝 Updated Pinned Message arrived: $data',
        name: 'SocketService.updatedPinnedMessage',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          await LocalChat().updatePinnedMessage(MessageModel.fromMap(data));
        }
      } catch (e) {
        AppLog.error('Error updating pinned message: $e');
      }
    });

    socket!.on('new-pinned-message', (dynamic data) async {
      AppLog.info(
        '📝 New Pinned Message arrived: $data',
        name: 'SocketService.newPinnedMessage',
      );
      if (data == null) return;
      try {
        if (data is Map<String, dynamic>) {
          await LocalChat().updatePinnedMessage(MessageModel.fromMap(data));
        }
      } catch (e) {
        AppLog.error('Error saving new pinned message: $e');
      }
    });

    socket!.onAny((String event, dynamic data) {
      debugPrint('📡 Event: $event');
      debugPrint('📦 Data: $data');
    });

    socket!.onAnyOutgoing((String event, dynamic data) {
      AppLog.info(
        '📤 Outgoing: $event → $data',
        name: 'SocketService.outgoing',
      );
    });
  }

  void disconnect() {
    socket?.disconnect();
    AppLog.info('⚠️ Manual disconnect', name: 'SocketService.disconnect');
  }
}
