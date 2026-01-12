import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../models/notification_model.dart';

class LocalNotifications extends LocalHiveBox<NotificationEntity> {
  @override
  String get boxName => AppStrings.localNotificationBox;

  /// Notifications may contain sensitive information - encrypt them.
  @override
  bool get requiresEncryption => true;

  /// Notifier that fires whenever the unread count changes.
  /// Listen to this to update badges in the UI.
  static final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  static Box<NotificationEntity>? get _boxOrNull {
    if (!Hive.isBoxOpen(AppStrings.localNotificationBox)) return null;
    return Hive.box<NotificationEntity>(AppStrings.localNotificationBox);
  }

  static Box<NotificationEntity> get _box =>
      Hive.box<NotificationEntity>(AppStrings.localNotificationBox);

  /// Updates the unread count notifier with the current count
  static void _updateUnreadCountNotifier() {
    final Box<NotificationEntity>? box = _boxOrNull;
    if (box == null) return;
    unreadCountNotifier.value = box.values
        .where((NotificationEntity e) => !e.isViewed)
        .length;
  }

  static Future<Box<NotificationEntity>> get openBox async =>
      await Hive.openBox<NotificationEntity>(AppStrings.localNotificationBox);

  /// Saves a notification based on its ID (updates if already exists)
  static Future<void> saveNotification(NotificationEntity notification) async {
    await _box.put(notification.notificationId, notification);
    _updateUnreadCountNotifier();
  }

  Future<void> handleNotificationData() async {}

  /// Get all notifications as a list
  static Future<List<NotificationEntity>> getAllNotifications() async {
    final List<NotificationEntity> list = _box.values
        .map(
          (NotificationEntity e) => NotificationModel(
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
            status: e.status,
            orderContext: e.orderContext,
          ),
        )
        .toList();

    list.sort(
      (NotificationEntity a, NotificationEntity b) =>
          b.timestamps.compareTo(a.timestamps),
    );
    return list;
  }

  /// Deletes a single notification by ID
  static Future<void> deleteNotification(String id) async {
    await _box.delete(id);
    _updateUnreadCountNotifier();
  }

  /// Initializes the unread count notifier. Call this at app startup
  /// after Hive boxes are opened.
  static void initializeUnreadCount() {
    _updateUnreadCountNotifier();
  }

  /// Marks a notification as viewed
  static Future<void> markAsViewed(String id) async {
    final NotificationEntity? notification = _box.get(id);
    if (notification != null && !notification.isViewed) {
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
        status: notification.status,
      );
      await _box.put(id, updated);
      _updateUnreadCountNotifier();
    }
  }

  /// Get a notification by its ID
  static Future<NotificationEntity?> getNotificationById(String id) async {
    return _box.get(id);
  }

  /// Get count of unread notifications
  static Future<int> getUnreadCount() async {
    return _box.values.where((NotificationEntity e) => !e.isViewed).length;
  }

  /// Marks all notifications as viewed
  static Future<void> markAllAsViewed() async {
    final List<NotificationEntity> unviewed = _box.values
        .where((NotificationEntity e) => !e.isViewed)
        .toList();

    for (final NotificationEntity notification in unviewed) {
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
        status: notification.status,
      );
      await _box.put(notification.notificationId, updated);
    }
    _updateUnreadCountNotifier();
  }

  /// Deletes notifications by their IDs
  static Future<void> deleteNotifications(List<String> notificationIds) async {
    for (final String id in notificationIds) {
      await _box.delete(id);
    }
    _updateUnreadCountNotifier();
  }
}
