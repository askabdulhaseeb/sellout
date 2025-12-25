import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../models/notification_model.dart';

abstract interface class NotificationRemote {
  Future<DataState<List<NotificationEntity>>> getAllNotifications();

  /// Marks all notifications as viewed on the server.
  Future<DataState<bool>> viewAllNotifications();

  /// Marks a single notification as viewed on the server.
  Future<DataState<bool>> viewSingleNotification(String notificationId);
}

class NotificationRemoteImpl implements NotificationRemote {
  @override
  Future<DataState<List<NotificationEntity>>> getAllNotifications() async {
    const String endpoint = '/notification/get';
    AppLog.info(
      'Starting to fetch all notifications. Endpoint: $endpoint',
      name: 'NotificationRemote.getAllNotifications',
    );

    // Try to get cached local data
    final ApiRequestEntity? localData = await LocalRequestHistory().request(
      endpoint: endpoint,
      duration: const Duration(days: 1),
    );

    // If local data exists, use it directly
    if (localData?.encodedData != null) {
      AppLog.info(
        'Using cached data from local storage',
        name: 'NotificationRemote.getAllNotifications',
      );
      final List<dynamic> decoded = json.decode(localData!.encodedData);
      final List<NotificationEntity> list = decoded
          .map((dynamic e) => NotificationModel.fromMap(e))
          .toList();
      AppLog.info(
        'Successfully loaded ${list.length} notifications from cache',
        name: 'NotificationRemote.getAllNotifications',
      );
      return DataSuccess<List<NotificationEntity>>('Success', list);
    }

    // If no cached data, hit the API
    AppLog.info(
      'No cache available, fetching from API',
      name: 'NotificationRemote.getAllNotifications',
    );
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
      AppLog.info(
        'Successfully fetched ${list.length} notifications from API',
        name: 'NotificationRemote.getAllNotifications',
      );
      return DataSuccess<List<NotificationEntity>>('Success', list);
    } else {
      final String errorMsg = result.exception?.message ?? 'Unknown error';
      final String errorDetails = result.exception.toString();
      AppLog.error(
        'Failed to fetch notifications. '
        'Endpoint: $endpoint, '
        'Error: $errorMsg, '
        'Details: $errorDetails',
        name: 'NotificationRemote.getAllNotifications',
      );
      return DataFailer<List<NotificationEntity>>(
        CustomException('Failed to get notifications: $errorMsg'),
      );
    }
  }

  @override
  Future<DataState<bool>> viewAllNotifications() async {
    const String endpoint = '/notification/view/all';
    AppLog.info(
      'Starting request to mark all notifications as viewed. Endpoint: $endpoint',
      name: 'NotificationRemote.viewAllNotifications',
    );

    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
      isAuth: true,
    );

    if (result is DataSuccess) {
      AppLog.info(
        'Successfully marked all notifications as viewed. Response: ${result.data}',
        name: 'NotificationRemote.viewAllNotifications',
      );
      return DataSuccess<bool>('Success', true);
    } else {
      final String errorMsg = result.exception?.message ?? 'Unknown error';
      AppLog.error(
        'Failed to mark notifications as viewed. ',
        name: 'NotificationRemote.viewAllNotifications - error',
        error: result.exception?.reason,
      );
      return DataFailer<bool>(
        CustomException('Failed to view all notifications: $errorMsg'),
      );
    }
  }

  @override
  Future<DataState<bool>> viewSingleNotification(String notificationId) async {
    final String endpoint = '/notification/view/$notificationId';
    AppLog.info(
      'Marking single notification as viewed. ID: $notificationId, Endpoint: $endpoint',
      name: 'NotificationRemote.viewSingleNotification',
    );

    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.post,
      isAuth: true,
    );

    if (result is DataSuccess) {
      AppLog.info(
        'Successfully marked notification as viewed. ID: $notificationId',
        name: 'NotificationRemote.viewSingleNotification',
      );
      return DataSuccess<bool>('Success', true);
    } else {
      final String errorMsg = result.exception?.message ?? 'Unknown error';
      AppLog.error(
        'Failed to mark notification as viewed. ID: $notificationId',
        name: 'NotificationRemote.viewSingleNotification',
        error: result.exception?.reason,
      );
      return DataFailer<bool>(
        CustomException('Failed to view notification: $errorMsg'),
      );
    }
  }
}
