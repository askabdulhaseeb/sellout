import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../functions/app_log.dart';
import 'socket_implementations.dart';

class SocketService with WidgetsBindingObserver{
  SocketService(this._socketImplementations);
  final SocketImplementations _socketImplementations;
  IO.Socket? socket;
   bool _isInitialized = false;

  bool get isConnected => socket?.connected ?? false;

  void initAndConnect() {
    if (_isInitialized) return;

    _isInitialized = true;
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  void connect() {
    final String? baseUrl = dotenv.env['baseURL'];
    final String? entityId = LocalAuth.uid;

    if (baseUrl == null || entityId == null) {
      AppLog.error('Missing baseURL or userId (entityId)', name: 'SocketService.connect');
      return;
    }

    if (socket != null && socket!.connected) return;

    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 2000,
      'query': <String, String>{'entity_id': entityId},
      'withCredentials': true,
    });

    socket!.connect();
    socket!.onConnect((_) {
      AppLog.info('✅ Connected to server: ${socket!.id}');
    });
    socket!.onConnectError((dynamic data) {
      AppLog.error('🚨 Connect error: $data');
    });
    socket!.onDisconnect((_) {
      AppLog.error('❌ Disconnected from server');
    });
    socket!.onDisconnect((_) {
      AppLog.error('❌ Disconnected from server',
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

    socket!.on('lastSeen', (dynamic data) {
      AppLog.info('🕓 Last seen: $data', name: 'SocketService.lastSeen');
    });

    socket!.on('newMessage', (dynamic data) async {
      AppLog.info('📨 New message received: $data',
          name: 'SocketService.newMessage');
      await _socketImplementations.handleNewMessage(data);
    });

    socket!.on('updatedMessage', (dynamic data) async {
      AppLog.info('📝 Message update arrived: $data',
          name: 'SocketService.updatedMessage');
      await _socketImplementations.handleUpdatedMessage(data);
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
