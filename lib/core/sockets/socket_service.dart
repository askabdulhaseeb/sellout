import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../functions/app_log.dart';
import 'handlers/socket_handler_registry.dart';

/// Thin socket connection manager that delegates event handling to registry.
///
/// Responsibilities:
/// - Connection lifecycle management
/// - Authentication handshake
/// - Event routing to SocketHandlerRegistry
///
/// Usage:
/// ```dart
/// final registry = SocketHandlerRegistry();
/// registry.registerHandler(PresenceHandler());
/// registry.registerHandler(ChatHandler());
///
/// final socketService = SocketService(registry);
/// socketService.initAndListen();
/// ```
class SocketService with WidgetsBindingObserver {
  SocketService(this._registry);

  final SocketHandlerRegistry _registry;
  io.Socket? socket;
  bool _isInitialized = false;

  bool get isConnected => socket?.connected ?? false;

  void initAndListen() {
    if (_isInitialized) return;
    _isInitialized = true;
    WidgetsBinding.instance.addObserver(this);

    LocalAuth.uidNotifier.addListener(_onAuthStateChanged);

    if (LocalAuth.uid != null) {
      connect();
    } else {
      AppLog.info(
        'No UID at startup. Socket will not connect.',
        name: 'SocketService',
      );
    }
  }

  void _onAuthStateChanged() {
    final String? uid = LocalAuth.uidNotifier.value;
    if (uid != null) {
      AppLog.info('UID set. Connecting socket...', name: 'SocketService');
      connect();
    } else {
      AppLog.info('UID is null. Disconnecting socket...', name: 'SocketService');
      disconnect();
    }
  }

  void connect() {
    final String? baseUrl = dotenv.env['baseURL'];
    final String? entityId = LocalAuth.uid;

    if (baseUrl == null || baseUrl.isEmpty) {
      AppLog.error('Missing baseURL', name: 'SocketService');
      return;
    }

    if (entityId == null || entityId.isEmpty) {
      AppLog.error('Missing userId (entityId)', name: 'SocketService');
      return;
    }

    if (socket != null && socket!.connected) {
      AppLog.info('Socket already connected', name: 'SocketService');
      return;
    }

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
      AppLog.error('Failed to create socket', name: 'SocketService');
      return;
    }

    socket!.connect();
    _setupSocketListeners();
    _registerEventHandlers();
  }

  void _setupSocketListeners() {
    socket!.onConnect((_) {
      AppLog.info(
        'Connected to server: ${socket?.id ?? 'unknown'}',
        name: 'SocketService',
      );
    });

    socket!.onConnectError((dynamic data) {
      AppLog.error('Connect error: $data', name: 'SocketService');
    });

    socket!.onDisconnect((_) {
      AppLog.error('Disconnected from server', name: 'SocketService');
    });

    socket!.onAny((String event, dynamic data) {
      debugPrint('Event: $event');
      debugPrint('Data: $data');
    });

    socket!.onAnyOutgoing((String event, dynamic data) {
      AppLog.info('Outgoing: $event -> $data', name: 'SocketService');
    });
  }

  void _registerEventHandlers() {
    // Register listeners for all events in the registry
    for (final String eventName in _registry.registeredEvents) {
      socket!.on(eventName, (dynamic data) async {
        AppLog.info('Received event: $eventName', name: 'SocketService');
        await _registry.dispatch(eventName, data);
      });
    }
  }

  void disconnect() {
    socket?.disconnect();
    AppLog.info('Manual disconnect', name: 'SocketService');
  }

  /// Emit an event to the server.
  void emit(String event, [dynamic data]) {
    if (socket == null || !socket!.connected) {
      AppLog.error(
        'Cannot emit "$event": socket not connected',
        name: 'SocketService',
      );
      return;
    }
    socket!.emit(event, data);
    AppLog.info('Emitted: $event', name: 'SocketService');
  }

  /// Emit joinChat event when user opens a chat screen.
  void joinChat(String chatId) {
    emit('joinChat', <String, dynamic>{'chat_id': chatId});
  }

  /// Emit leaveChat event when user leaves a chat screen.
  void leaveChat(String chatId) {
    emit('leaveChat', <String, dynamic>{'chat_id': chatId});
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    LocalAuth.uidNotifier.removeListener(_onAuthStateChanged);
    disconnect();
    _registry.clear();
  }
}
