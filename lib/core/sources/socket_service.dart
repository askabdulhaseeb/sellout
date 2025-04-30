import 'package:easy_localization/easy_localization.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../functions/app_log.dart';

class SocketService {
  IO.Socket? socket;

  void connect() {
    // Connect to your server's Socket.IO URL
    socket = IO.io('https://your-server-url.com', <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
    });

    // Handle connection
    socket?.on('connect', (_) {
      AppLog.info('Connected to server');
    });

    // Listen for incoming messages
    socket?.on('new_message', (dynamic data) {
      AppLog.info('New message received: $data',
          name: 'SocketService.new_message');
      // Update the UI or take appropriate action
    });
  }

  // Send a message to the server
  void sendMessage(String message) {
    socket?.emit('send_message.'.tr(), message);
  }

  // Disconnect from the server
  void disconnect() {
    socket?.disconnect();
    AppLog.error('Disconnected_from_server'.tr());
  }
}
