import 'package:flutter/foundation.dart';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/sources/local/local_request_history.dart';
import '../local/local_user.dart';

abstract interface class UserProfileRemoteSource {
  Future<DataState<UserModel?>> byUID(String value);
}

class UserProfileRemoteSourceImpl implements UserProfileRemoteSource {
  @override
  Future<DataState<UserModel?>> byUID(String value) async {
    if (value.isEmpty) {
      return DataFailer<UserModel?>(CustomException('User ID is null'));
    }
    final String endpoint = '/user/$value';
    try {
      ApiRequestEntity? request = await LocalRequestHistory().request(
          endpoint: endpoint,
          duration: kDebugMode
              ? const Duration(seconds: 10)
              : const Duration(minutes: 30));
      if (request != null) {
        final DataState<UserModel?> local = LocalUser().userState(value);
        if (local is DataSuccess<UserModel?> && local.entity != null) {
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
        final UserModel entity = UserModel.fromRawJson(data);
        await LocalUser().save(entity);
        return DataSuccess<UserModel>(data, entity);
      }
      return DataFailer<UserModel?>(CustomException('User not found'));
    } catch (e) {
      debugPrint('❌ Error GetUserAPI.user: catch $e');
    }
    return DataFailer<UserModel?>(CustomException('User not found'));
  }
}
