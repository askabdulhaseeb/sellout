import 'package:flutter/foundation.dart';

import '../../functions/app_log.dart';
import '../../utilities/app_string.dart';
import 'base_socket_handler.dart';

/// Handles user presence events (online/offline status, last seen).
/// Maintains shared state via ValueNotifiers for UI reactivity.
///
/// Usage:
/// ```dart
/// final handler = PresenceHandler();
///
/// // Listen to online users
/// ValueListenableBuilder<List<String>>(
///   valueListenable: handler.onlineUsers,
///   builder: (context, users, _) => Text('Online: ${users.length}'),
/// );
///
/// // Check if user is online
/// final isOnline = handler.isUserOnline(userId);
/// ```
class PresenceHandler extends BaseSocketHandler {
  /// Notifier for online users list. Listen to this for UI updates.
  final ValueNotifier<List<String>> onlineUsers =
      ValueNotifier<List<String>>(<String>[]);

  /// Notifier for last seen timestamps. Maps entityId -> lastSeen timestamp.
  final ValueNotifier<Map<String, String>> lastSeenMap =
      ValueNotifier<Map<String, String>>(<String, String>{});

  @override
  List<String> get supportedEvents => <String>[
        AppStrings.getOnlineUsers,
        AppStrings.userOnline,
        AppStrings.userOffline,
        AppStrings.lastSeen, 
      ];

  @override
  Future<void> handleEvent(String eventName, dynamic data) async {
    if (data == null) return;

    switch (eventName) {
      case 'getOnlineUsers':
        await _handleInitialOnlineUsers(data);
        break;
      case 'userOnline':
        _handleUserOnline(data);
        break;
      case 'userOffline':
        _handleUserOffline(data);
        break;
      case 'lastSeen':
        _handleLastSeen(data);
        break;
    }
  }

  Future<void> _handleInitialOnlineUsers(dynamic data) async {
    try {
      final List<String> users = List<String>.from(data);
      onlineUsers.value = users;
      AppLog.info(
        'Initial online users: ${users.length}',
        name: 'PresenceHandler',
      );
    } catch (e) {
      AppLog.error('Error parsing online users: $e', name: 'PresenceHandler');
    }
  }

  void _handleUserOnline(dynamic data) {
    try {
      final String entityId = data is String ? data : data.toString();
      final List<String> currentUsers = List<String>.from(onlineUsers.value);

      if (!currentUsers.contains(entityId)) {
        currentUsers.add(entityId);
        onlineUsers.value = currentUsers;
      }

      // Remove from last seen map when user comes online
      final Map<String, String> currentLastSeen =
          Map<String, String>.from(lastSeenMap.value);
      currentLastSeen.remove(entityId);
      lastSeenMap.value = currentLastSeen;

      AppLog.info(
        'User online: $entityId | Total: ${onlineUsers.value.length}',
        name: 'PresenceHandler',
      );
    } catch (e) {
      AppLog.error('Error handling userOnline: $e', name: 'PresenceHandler');
    }
  }

  void _handleUserOffline(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        final String entityId = data['entityId']?.toString() ?? '';
        final String lastSeen = data['lastSeen']?.toString() ?? '';

        if (entityId.isEmpty) return;

        final List<String> currentUsers = List<String>.from(onlineUsers.value);
        currentUsers.remove(entityId);
        onlineUsers.value = currentUsers;

        if (lastSeen.isNotEmpty) {
          final Map<String, String> currentLastSeen =
              Map<String, String>.from(lastSeenMap.value);
          currentLastSeen[entityId] = lastSeen;
          lastSeenMap.value = currentLastSeen;
        }

        AppLog.info(
          'User offline: $entityId | Total: ${onlineUsers.value.length}',
          name: 'PresenceHandler',
        );
      }
    } catch (e) {
      AppLog.error('Error handling userOffline: $e', name: 'PresenceHandler');
    }
  }

  void _handleLastSeen(dynamic data) {
    AppLog.info('Last seen event: $data', name: 'PresenceHandler');
  }

  /// Check if a user is currently online.
  bool isUserOnline(String entityId) => onlineUsers.value.contains(entityId);

  /// Get last seen timestamp for a user.
  String? getLastSeen(String entityId) => lastSeenMap.value[entityId];

  @override
  void dispose() {
    onlineUsers.dispose();
    lastSeenMap.dispose();
  }
}
