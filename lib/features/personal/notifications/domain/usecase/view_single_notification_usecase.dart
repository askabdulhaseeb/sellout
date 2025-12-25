import '../../../../../core/usecase/usecase.dart';
import '../repo/notification_repo.dart';

/// Use case to mark a single notification as viewed.
/// Calls the /notification/view/{notificationId} endpoint.
class ViewSingleNotificationUseCase implements UseCase<bool, String> {
  ViewSingleNotificationUseCase(this.repository);
  final NotificationRepository repository;

  @override
  Future<DataState<bool>> call(String notificationId) {
    return repository.viewSingleNotification(notificationId);
  }
}
