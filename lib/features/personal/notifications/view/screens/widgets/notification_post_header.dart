import 'package:flutter/material.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationPostHeader extends StatelessWidget {
  const NotificationPostHeader({
    required this.notification,
    required this.timeText,
    required this.isUnread,
    super.key,
  });
  final NotificationEntity notification;
  final String timeText;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            notification.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          timeText,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
