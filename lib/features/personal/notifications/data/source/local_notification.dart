import 'package:hive/hive.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

class LocalNotifications {
  static final String _boxName = AppStrings.localNotificationBox;
  static Box<NotificationEntity>? _box;

  /// Opens the Hive box (only once)
  static Future<void> refresh() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<NotificationEntity>(_boxName);
    } else {
      _box = Hive.box<NotificationEntity>(_boxName);
    }
  }

  /// Clears all notifications
  static Future<void> clear() async {
    await refresh();
    await _box!.clear();
  }

  /// Saves a notification based on its ID (updates if already exists)
  static Future<void> saveNotification(NotificationModel notification) async {
    await refresh();
    await _box!.put(notification.notificationId, notification);
  }

  /// Get all notifications as a list
  static Future<List<NotificationModel>> getAllNotifications() async {
    await refresh();
    return _box!.values
        .map((e) => NotificationModel(
              notificationId: e.notificationId,
              userId: e.userId,
              type: e.type,
              title: e.title,
              deliverTo: e.deliverTo,
              message: e.message,
              isViewed: e.isViewed,
              metadata: e.metadata,
              notificationFor: e.notificationFor,
              timestamps: e.timestamps,
            ))
        .toList();
  }

  /// Deletes a single notification by ID
  static Future<void> deleteNotification(String id) async {
    await refresh();
    await _box!.delete(id);
  }

  /// Marks a notification as viewed
  static Future<void> markAsViewed(String id) async {
    await refresh();
    final notification = _box!.get(id);
    if (notification != null) {
      final updated = NotificationModel(
        notificationId: notification.notificationId,
        userId: notification.userId,
        type: notification.type,
        title: notification.title,
        deliverTo: notification.deliverTo,
        message: notification.message,
        isViewed: true,
        metadata: notification.metadata,
        notificationFor: notification.notificationFor,
        timestamps: notification.timestamps,
      );
      await _box!.put(id, updated);
    }
  }

  /// Get count of unread notifications
  static Future<int> getUnreadCount() async {
    await refresh();
    return _box!.values.where((e) => !e.isViewed).length;
  }
}
