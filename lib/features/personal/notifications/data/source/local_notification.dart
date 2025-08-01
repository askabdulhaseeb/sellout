import 'package:hive/hive.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

class LocalNotifications {
  static final String boxTitle = AppStrings.localNotificationBox;
  static Box<NotificationEntity> get _box =>
      Hive.box<NotificationEntity>(boxTitle);

  static Future<Box<NotificationEntity>> get openBox async =>
      await Hive.openBox<NotificationEntity>(boxTitle);

  /// Opens the Hive box
  Future<Box<NotificationEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox(boxTitle);
    }
  }

  /// Clears all notifications
  Future<void> clear() async => await _box.clear();

  /// Saves a notification based on its ID (updates if already exists)
  static Future<void> saveNotification(NotificationEntity notification) async {
    await _box.put(notification.notificationId, notification);
  }

  /// Get all notifications as a list
  static Future<List<NotificationEntity>> getAllNotifications() async {
    return _box.values
        .map((NotificationEntity e) => NotificationModel(
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
    await _box.delete(id);
  }

  /// Marks a notification as viewed
  static Future<void> markAsViewed(String id) async {
    final NotificationEntity? notification = _box.get(id);
    if (notification != null) {
      final NotificationModel updated = NotificationModel(
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
      await _box.put(id, updated);
    }
  }

  /// Get count of unread notifications
  static Future<int> getUnreadCount() async {
    return _box.values.where((NotificationEntity e) => !e.isViewed).length;
  }
}
