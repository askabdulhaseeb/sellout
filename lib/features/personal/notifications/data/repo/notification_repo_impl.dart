import '../../../../../../../core/sources/api_call.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repo/notification_repo.dart';
import '../source/remote/remote_notification.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this.remote);
  final NotificationRemote remote;

  @override
  Future<DataState<List<NotificationEntity>>> getAllNotifications() {
    return remote.getAllNotifications();
  }

  @override
  Future<DataState<bool>> viewAllNotifications() {
    return remote.viewAllNotifications();
  }
}
