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
    notifyListeners();
  }

  Future<void> fetchNotificationsByType() async {
    setLoading(true);
    final DataState<List<NotificationEntity>> result =
        await getAllNotificationsUsecase(null);
    if (result is DataSuccess<List<NotificationEntity>>) {
      notifications = (result.entity ?? <NotificationEntity>[])
          .where((NotificationEntity n) =>
              _selectedNotificationType == NotificationType.all ||
              n.type == _selectedNotificationType.jsonKey)
          .toList();
    } else {
      AppLog.error('NotificationProvider.fetchNotificationsByType',
          error: result.exception?.message ?? 'something_wrong');
    }
    setLoading(false);
  }
}
