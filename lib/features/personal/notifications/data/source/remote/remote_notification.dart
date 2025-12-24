import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../models/notification_model.dart';

abstract interface class NotificationRemote {
  Future<DataState<List<NotificationEntity>>> getAllNotifications();

  /// Marks all notifications as viewed on the server.
  Future<DataState<bool>> viewAllNotifications();
}

class NotificationRemoteImpl implements NotificationRemote {
  @override
  Future<DataState<List<NotificationEntity>>> getAllNotifications() async {
    const String endpoint = '/notification/get';

    // Try to get cached local data
    final ApiRequestEntity? localData = await LocalRequestHistory().request(
      endpoint: endpoint,
      duration: const Duration(days: 1),
    );

    // If local data exists, use it directly
    if (localData?.encodedData != null) {
      final List<dynamic> decoded = json.decode(localData!.encodedData);
      final List<NotificationEntity> list = decoded
          .map((dynamic e) => NotificationModel.fromMap(e))
          .toList();
      return DataSuccess<List<NotificationEntity>>('Success', list);
    }

    // If no cached data, hit the API
    final DataState<String> result = await ApiCall<String>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.get,
      isAuth: true,
    );

    if (result is DataSuccess<String>) {
      final String raw = result.data ?? '';
      final List<dynamic> decoded = json.decode(raw);
      final List<NotificationEntity> list = decoded
          .map((dynamic e) => NotificationModel.fromMap(e))
          .toList();
      return DataSuccess<List<NotificationEntity>>('Success', list);
    } else {
      AppLog.error('NotificationRemote.getAllNotifications');
      return DataFailer<List<NotificationEntity>>(CustomException('Failed'));
    }
  }

  @override
  Future<DataState<bool>> viewAllNotifications() async {
    const String endpoint = '/notification/view/all';

    final DataState<String> result = await ApiCall<String>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
      isAuth: true,
    );

    if (result is DataSuccess<String>) {
      return DataSuccess<bool>('Success', true);
    } else {
      AppLog.error('NotificationRemote.viewAllNotifications');
      return DataFailer<bool>(CustomException('Failed'));
    }
  }
}
