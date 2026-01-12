import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/notification_entity.dart';

/// Badge widget that displays the total count of unread notifications.
/// Listens to the Hive box for real-time updates.
class UnreadNotificationsBadgeWidget extends StatelessWidget {
  const UnreadNotificationsBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<NotificationEntity> notificationBox =
        Hive.box<NotificationEntity>(AppStrings.localNotificationBox);

    return ValueListenableBuilder<Box<NotificationEntity>>(
      valueListenable: notificationBox.listenable(),
      builder: (BuildContext context, Box<NotificationEntity> box, _) {
        int unreadCount = 0;
        for (final NotificationEntity notification in box.values) {
          if (!notification.isViewed) {
            unreadCount++;
          }
        }

        if (unreadCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          alignment: Alignment.center,
          child: Text(
            unreadCount > 99 ? '99+' : unreadCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
