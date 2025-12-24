import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/widgets/notifications_list_section.dart';
import '../../domain/entities/notification_entity.dart';
import '../provider/notification_provider.dart';
import '../screens/widgets/notifications_filter_toggle.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static String routeName = 'notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final NotificationProvider provider = context.read<NotificationProvider>();
      provider.bootstrap();
      // Mark all notifications as viewed when screen opens
      provider.viewAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const AppBarTitle(titleKey: 'notifications'),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (BuildContext context, NotificationProvider provider, _) {
          final List<NotificationEntity> notifications = provider.notifications;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                NotificationsFilterToggle(
                  value: provider.selectedNotificationType,
                  onChanged: provider.setNotificationType,
                ),
                NotificationsListSection(notifications: notifications),
              ],
            ),
          );
        },
      ),
    );
  }
}
