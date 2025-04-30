import 'package:easy_localization/easy_localization.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../functions/app_log.dart';

class SocketService {
  IO.Socket? socket;

  void connect() {
    socket = IO.io('https://your-server-url.com', <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) {
      AppLog.info('Connected to server', name: 'SocketService.connect');
    });

    socket?.on('new_message', (dynamic data) {
      AppLog.info('New message received: $data', name: 'SocketService.new_message');
    });
  }

  void sendMessage(String message) {
    socket?.emit('send_message.'.tr(), message);
    AppLog.info('Message sent: $message', name: 'SocketService.sendMessage');
  }

  void disconnect() {
    socket?.disconnect();
    AppLog.error('Disconnected_from_server'.tr(), name: 'SocketService.disconnect');
  }
}
