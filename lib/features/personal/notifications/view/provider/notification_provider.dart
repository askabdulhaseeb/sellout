import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../data/source/local/local_notification.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';
import '../../domain/usecase/delete_notifications_usecase.dart';
import '../../domain/usecase/get_all_notifications_usecase.dart';
import '../../domain/usecase/view_all_notifications_usecase.dart';
import '../../domain/usecase/view_single_notification_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(
    this.getAllNotificationsUsecase,
    this.viewAllNotificationsUsecase,
    this.viewSingleNotificationUsecase,
    this.deleteNotificationsUsecase,
  );
  final GetAllNotificationsUseCase getAllNotificationsUsecase;
  final ViewAllNotificationsUseCase viewAllNotificationsUsecase;
  final ViewSingleNotificationUseCase viewSingleNotificationUsecase;
  final DeleteNotificationsUseCase deleteNotificationsUsecase;

  bool _isLoading = false;
  List<NotificationEntity> _allNotifications = <NotificationEntity>[];
  List<NotificationEntity> notifications = <NotificationEntity>[];
  NotificationType _selectedNotificationType = NotificationType.all;

  bool get isLoading => _isLoading;
  NotificationType get selectedNotificationType => _selectedNotificationType;

  Future<void> bootstrap() async {
    await refreshFromLocal();
    // Fire-and-forget remote refresh.
    fetchNotificationsByType();
  }

  Future<void> refreshFromLocal() async {
    try {
      final List<NotificationEntity> local =
          await LocalNotifications.getAllNotifications();
      _allNotifications = local;
      _allNotifications.sort(
        (NotificationEntity a, NotificationEntity b) =>
            b.timestamps.compareTo(a.timestamps),
      );
      _applyFilter();
      notifyListeners();
    } catch (e) {
      AppLog.error(
        'NotificationProvider.refreshFromLocal',
        error: e.toString(),
      );
    }
  }

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setNotificationType(NotificationType val) {
    _selectedNotificationType = val;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    notifications = _allNotifications.where((NotificationEntity n) {
      if (_selectedNotificationType == NotificationType.all) return true;

      if (_selectedNotificationType == NotificationType.share) {
        final String postId = (n.metadata.postId)?.trim() ?? '';
        return postId.isNotEmpty;
      }

      return _selectedNotificationType.containsCid(n.type);
    }).toList();
  }

  void applyFilterOnly() {
    _applyFilter();
    notifyListeners();
  }

  Future<void> fetchNotificationsByType() async {
    if (_isLoading) return;
    setLoading(true);
    final DataState<List<NotificationEntity>> result =
        await getAllNotificationsUsecase(null);
    if (result is DataSuccess<List<NotificationEntity>>) {
      final List<NotificationEntity> fetched =
          result.entity ?? <NotificationEntity>[];
      try {
        for (final NotificationEntity n in fetched) {
          await LocalNotifications.saveNotification(n);
        }
      } catch (e) {
        AppLog.error(
          'NotificationProvider.fetchNotificationsByType.saveLocal',
          error: e.toString(),
        );
      }

      // Always render from local so UI is consistent with what's stored.
      await refreshFromLocal();
    } else {
      AppLog.error(
        'NotificationProvider.fetchNotificationsByType',
        error: result.exception?.message ?? 'something_wrong',
      );
    }
    setLoading(false);
  }

  /// Marks all notifications as viewed on the server and locally.
  Future<bool> viewAllNotifications() async {
    final DataState<bool> result = await viewAllNotificationsUsecase(null);

    if (result is DataSuccess<bool>) {
      try {
        // Mark all local notifications as viewed immediately
        await LocalNotifications.markAllAsViewed();
        AppLog.info(
          'Local notifications marked as viewed. Refreshing from local storage...',
          name: 'NotificationProvider.viewAllNotifications',
        );
        await refreshFromLocal();
        return true;
      } catch (e) {
        AppLog.error(
          'Server update succeeded but local update failed. Error: $e',
          name: 'NotificationProvider.viewAllNotifications',
        );
        return false;
      }
    } else {
      final String errorMsg = result.exception?.message ?? 'something_wrong';
      final String errorDetails = result.exception.toString();
      AppLog.error(
        'Failed to mark notifications as viewed on server. '
        'Error: $errorMsg, '
        'Details: $errorDetails, '
        'Total notifications: ${_allNotifications.length}',
        name: 'NotificationProvider.viewAllNotifications',
      );
      return false;
    }
  }

  /// Marks a single notification as viewed on the server and locally.
  Future<bool> viewSingleNotification(String notificationId) async {
    AppLog.info(
      'Marking single notification as viewed. ID: $notificationId',
      name: 'NotificationProvider.viewSingleNotification',
    );

    final DataState<bool> result = await viewSingleNotificationUsecase(
      notificationId,
    );

    if (result is DataSuccess<bool>) {
      try {
        // Mark local notification as viewed without refreshing UI
        await LocalNotifications.markAsViewed(notificationId);
        AppLog.info(
          'Successfully marked notification as viewed. ID: $notificationId',
          name: 'NotificationProvider.viewSingleNotification',
        );
        // Don't refresh to avoid UI glitches during scroll
        return true;
      } catch (e) {
        AppLog.error(
          'Server update succeeded but local update failed. Error: $e',
          name: 'NotificationProvider.viewSingleNotification',
        );
        return false;
      }
    } else {
      final String errorMsg = result.exception?.message ?? 'something_wrong';
      AppLog.error(
        'Failed to mark notification as viewed. ID: $notificationId, Error: $errorMsg',
        name: 'NotificationProvider.viewSingleNotification',
      );
      return false;
    }
  }

  /// Deletes one or more notifications by their IDs
  Future<bool> deleteNotifications(List<String> notificationIds) async {
    AppLog.info(
      'Deleting ${notificationIds.length} notifications',
      name: 'NotificationProvider.deleteNotifications',
    );

    final DataState<bool> result = await deleteNotificationsUsecase(
      notificationIds,
    );

    if (result is DataSuccess<bool>) {
      try {
        // Delete from local storage
        await LocalNotifications.deleteNotifications(notificationIds);
        AppLog.info(
          'Successfully deleted ${notificationIds.length} notifications',
          name: 'NotificationProvider.deleteNotifications',
        );
        // Refresh the list
        await refreshFromLocal();
        return true;
      } catch (e) {
        AppLog.error(
          'Server deletion succeeded but local deletion failed. Error: $e',
          name: 'NotificationProvider.deleteNotifications',
        );
        return false;
      }
    } else {
      final String errorMsg = result.exception?.message ?? 'something_wrong';
      AppLog.error(
        'Failed to delete notifications. Error: $errorMsg',
        name: 'NotificationProvider.deleteNotifications',
      );
      return false;
    }
  }
}
