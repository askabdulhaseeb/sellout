import '../../../../../core/usecase/usecase.dart';
import '../entities/notification_entity.dart';
import '../repo/notification_repo.dart';

class GetAllNotificationsUseCase
    implements UseCase<List<NotificationEntity>, void> {
  GetAllNotificationsUseCase(this.repository);
  final NotificationRepository repository;

  @override
  Future<DataState<List<NotificationEntity>>> call(void params) {
    return repository.getAllNotifications();
  }
}
