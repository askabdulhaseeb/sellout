import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../data/source/local/local_notification.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';
import '../../domain/usecase/get_all_notifications_usecase.dart';
import '../../domain/usecase/view_all_notifications_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(
    this.getAllNotificationsUsecase,
    this.viewAllNotificationsUsecase,
  );
  final GetAllNotificationsUseCase getAllNotificationsUsecase;
  final ViewAllNotificationsUseCase viewAllNotificationsUsecase;

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
      // Mark all local notifications as viewed
      for (final NotificationEntity n in _allNotifications) {
        if (!n.isViewed) {
          await LocalNotifications.markAsViewed(n.notificationId);
        }
      }
      await refreshFromLocal();
      return true;
    } else {
      AppLog.error(
        'NotificationProvider.viewAllNotifications',
        error: result.exception?.message ?? 'something_wrong',
      );
      return false;
    }
  }
}
