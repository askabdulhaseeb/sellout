import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../view/params/change_password_params.dart';

abstract class SettingRemoteApi {
  Future<DataState<bool>> changePassword(
      {required ChangePasswordParams params});
}

class SettingRemoteApiImpl implements SettingRemoteApi {
  @override
  Future<DataState<bool>> changePassword(
      {required ChangePasswordParams params}) async {
    const String endpoint = '/userAuth/change/password?source=setting';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(params.toJson()),
      );
      if (result is DataSuccess) {
        AppLog.info('Password changed',
            name: 'SettingRemoteApi.changePassword - success');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.reason ?? 'Unknown error',
          name: 'SettingRemoteApi.changePassword - else',
          error: result.exception?.reason,
        );
        return result;
      }
    } catch (e, stk) {
      AppLog.error(
        e.toString(),
        name: 'changePassword - catch',
        error: e,
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
