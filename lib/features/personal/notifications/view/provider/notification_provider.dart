import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';
import '../../domain/usecase/get_all_notifications_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this.getAllNotificationsUsecase);
  final GetAllNotificationsUseCase getAllNotificationsUsecase;

  bool _isLoading = false;
  List<NotificationEntity> _allNotifications = <NotificationEntity>[];
  List<NotificationEntity> notifications = <NotificationEntity>[];
  NotificationType _selectedNotificationType = NotificationType.all;

  bool get isLoading => _isLoading;
  NotificationType get selectedNotificationType => _selectedNotificationType;

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
        final String postId = (n.metadata['post_id'] as String?)?.trim() ?? '';
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
      _allNotifications = result.entity ?? <NotificationEntity>[];
      _applyFilter();
    } else {
      AppLog.error(
        'NotificationProvider.fetchNotificationsByType',
        error: result.exception?.message ?? 'something_wrong',
      );
    }
    setLoading(false);
  }
}
