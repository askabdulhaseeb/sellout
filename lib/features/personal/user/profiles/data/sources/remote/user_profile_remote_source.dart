import 'package:flutter/foundation.dart';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/sources/local/local_request_history.dart';
import '../local/local_user.dart';

abstract interface class UserProfileRemoteSource {
  Future<DataState<UserEntity?>> byUID(String value);
}

class UserProfileRemoteSourceImpl implements UserProfileRemoteSource {
  @override
  Future<DataState<UserEntity?>> byUID(String value) async {
    if (value.isEmpty) {
      return DataFailer<UserEntity?>(CustomException('User ID is null'));
    }
    final String endpoint = '/user/$value';
    try {
      ApiRequestEntity? request = await LocalRequestHistory().request(
          endpoint: endpoint,
          duration: kDebugMode
              ? const Duration(minutes: 10)
              : const Duration(hours: 1));
      if (request != null) {
        final DataState<UserEntity?> local = LocalUser().userState(value);
        if (local is DataSuccess<UserEntity?> && local.entity != null) {
          return local;
        }
      }
      //
      //
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: true,
        isConnectType: false,
        requestType: ApiRequestType.get,
      );
      //
      if (result is DataSuccess<bool>) {
        final String data = result.data ?? '';
        final UserEntity entity = UserModel.fromRawJson(data);
        await LocalUser().save(entity);
        return DataSuccess<UserEntity>(data, entity);
      }
      return DataFailer<UserEntity?>(CustomException('User not found'));
    } catch (e) {
      debugPrint('GetUserAPI.user: catch $e - $endpoint');
    }
    return DataFailer<UserEntity?>(CustomException('User not found'));
  }
}
