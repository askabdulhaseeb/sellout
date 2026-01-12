import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../domain/entities/notification_entity.dart';
import 'notification_tile.dart';

class NotificationsListSection extends StatelessWidget {
  const NotificationsListSection({required this.notifications, super.key});

  final List<NotificationEntity> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Expanded(
        child: Center(
          child: EmptyPageWidget(
            icon: CupertinoIcons.bell,
            childBelow: Text(
              'no_results'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}
