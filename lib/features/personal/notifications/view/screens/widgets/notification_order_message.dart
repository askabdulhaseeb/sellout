import 'package:flutter/material.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationOrderMessage extends StatelessWidget {
  const NotificationOrderMessage({required this.notification, super.key});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    return Text(
      notification.message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      ),
    );
  }
}
