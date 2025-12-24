import 'package:flutter/material.dart';

import '../../../../domain/entities/notification_entity.dart';

class NotificationActionDetector {
  static String detectAction(NotificationEntity notification) {
    final String type = notification.type.toLowerCase();

    // Post-related notifications (priority)
    if (type.contains('post') ||
        type.contains('like') ||
        type.contains('comment') ||
        type.contains('follow')) {
      return 'post';
    }

    // Chat/Message notifications
    if (type.contains('chat') || type.contains('message')) {
      return 'chat';
    }

    // Order-related notifications
    if (type.contains('order')) {
      return 'order';
    }

    // Fallback to first available
    if (notification.hasPost) return 'post';
    if (notification.hasChat) return 'chat';
    if (notification.hasOrder) return 'order';

    return 'none';
  }

  static String getButtonText(String action) {
    switch (action) {
      case 'order':
        return 'order';
      case 'chat':
        return 'chat';
      case 'post':
        return 'view';
      default:
        return 'open';
    }
  }

  static IconData? getButtonIcon(String action) {
    switch (action) {
      case 'order':
        return Icons.receipt_long;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'post':
        return Icons.visibility_outlined;
      default:
        return Icons.arrow_forward;
    }
  }
}
