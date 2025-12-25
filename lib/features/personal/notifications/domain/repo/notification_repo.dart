import '../../../../../../../core/sources/api_call.dart';
import '../entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<DataState<List<NotificationEntity>>> getAllNotifications();

  /// Marks all notifications as viewed on the server.
  Future<DataState<bool>> viewAllNotifications();

  /// Marks a single notification as viewed on the server.
  Future<DataState<bool>> viewSingleNotification(String notificationId);
}
