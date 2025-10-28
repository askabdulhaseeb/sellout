import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../domain/params/create_account_session_params.dart';
import '../../../view/params/change_password_params.dart';

abstract class SettingRemoteApi {
  Future<DataState<bool>> changePassword(
      {required ChangePasswordParams params});
  Future<DataState<String>> connectAccountSession(
      ConnectAccountSessionParams params);
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

  @override
  Future<DataState<String>> connectAccountSession(
    ConnectAccountSessionParams params
  ) async {
    const String endpoint = '/stripeAccount/session/create';

    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(params.toMap())
      );

      if (result is DataSuccess) {
        // Decode the raw response JSON
        final Map<String, dynamic> jsonData = json.decode(result.data!);
        final String sessionSecret = jsonData['url'];
        return DataSuccess<String>(
          result.data ?? '',
          sessionSecret,
        );
      } else if (result is DataFailer) {
        return DataFailer<String>(CustomException(
            result.exception?.message ?? 'something_wrong'.tr()));
      }
      return DataFailer<String>(
          CustomException(result.exception?.message ?? 'something_wrong'.tr()));
    } catch (e, stc) {
      AppLog.error('',
          name: 'SettingRemoteApiImpl.connectAccountSession - catch',
          error: e,
          stackTrace: stc);
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
