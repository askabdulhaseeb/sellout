import '../../../../../../core/usecase/usecase.dart';
import '../repo/notification_repo.dart';

class DeleteNotificationsUseCase implements UseCase<bool, List<String>> {
  DeleteNotificationsUseCase(this._repo);
  final NotificationRepository _repo;

  @override
  Future<DataState<bool>> call(List<String> notificationIds) async {
    return _repo.deleteNotifications(notificationIds);
  }
}
