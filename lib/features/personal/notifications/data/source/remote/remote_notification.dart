import 'package:flutter/foundation.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../models/notification_model.dart';

abstract interface class NotificationRemote {
  Future<DataState<List<NotificationEntity>>> getAllNotifications();
}

class NotificationRemoteImpl implements NotificationRemote {
  @override
  Future<DataState<List<NotificationEntity>>> getAllNotifications() async {
    const String endpoint = '/notification/get';
    final DataState<String> result = await ApiCall<String>().call(
      endpoint: endpoint,
      requestType: ApiRequestType.get,
      isAuth: true,
    );

    if (result is DataSuccess<String>) {
      final String raw = result.data ?? '';
      debugPrint(raw);
      final List<dynamic> decoded = json.decode(raw);
      final List<NotificationEntity> list =
          decoded.map((e) => NotificationModel.fromMap(e)).toList();

      // If you want to save locally:
      // for (final notification in list) {
      //   await LocalNotifications.save(notification);
      // }

      return DataSuccess<List<NotificationEntity>>('Success', list);
    } else {
      AppLog.error('NotificationRemote.getAllNotifications');
      return DataFailer<List<NotificationEntity>>(CustomException('Failed'));
    }
  }
}
