import '../../../../../core/usecase/usecase.dart';
import '../repo/notification_repo.dart';

/// Use case to mark all notifications as viewed.
/// Calls the /notification/view/all endpoint.
class ViewAllNotificationsUseCase implements UseCase<bool, void> {
  ViewAllNotificationsUseCase(this.repository);
  final NotificationRepository repository;

  @override
  Future<DataState<bool>> call(void params) {
    return repository.viewAllNotifications();
  }
}
