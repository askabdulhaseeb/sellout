import '../../../../../../../core/sources/api_call.dart';
import '../entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<DataState<List<NotificationEntity>>> getAllNotifications();
}
