import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../domain/params/create_account_session_params.dart';
import '../../../view/params/change_password_params.dart';

abstract class SettingRemoteApi {
  Future<DataState<bool>> changePassword({
    required ChangePasswordParams params,
  });
  Future<DataState<String>> connectAccountSession(
    ConnectAccountSessionParams params,
  );
  Future<DataState<bool>> getWallet(String walletId);
}

class SettingRemoteApiImpl implements SettingRemoteApi {
  @override
  Future<DataState<bool>> changePassword({
    required ChangePasswordParams params,
  }) async {
    const String endpoint = '/userAuth/change/password?source=setting';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(params.toJson()),
      );
      if (result is DataSuccess) {
        AppLog.info(
          'Password changed',
          name: 'SettingRemoteApi.changePassword - success',
        );
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
    ConnectAccountSessionParams params,
  ) async {
    const String endpoint = '/stripeAccount/session/create';

    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(params.toMap()),
      );

      if (result is DataSuccess) {
        final String? raw = result.data;
        if (raw == null || raw.trim().isEmpty) {
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }

        String? sessionUrl;

        bool looksLikeUrl(String s) => s.startsWith('http');

        try {
          final dynamic decoded = json.decode(raw);
          if (decoded is Map<String, dynamic>) {
            // Common key candidates for URL
            const List<String> keys = <String>[
              'url',
              'session_url',
              'redirect_url',
              'link',
              'sessionUrl',
            ];
            for (final String k in keys) {
              final dynamic v = decoded[k];
              if (v is String && v.isNotEmpty) {
                sessionUrl = v;
                break;
              }
            }
            // Nested `data` object case
            if (sessionUrl == null && decoded['data'] is Map<String, dynamic>) {
              final Map<String, dynamic> dataNode =
                  decoded['data'] as Map<String, dynamic>;
              for (final String k in keys) {
                final dynamic v = dataNode[k];
                if (v is String && v.isNotEmpty) {
                  sessionUrl = v;
                  break;
                }
              }
            }
            // Single-item map: take the first value if it's a URL
            if (sessionUrl == null && decoded.length == 1) {
              final dynamic onlyValue = decoded.values.first;
              if (onlyValue is String && looksLikeUrl(onlyValue)) {
                sessionUrl = onlyValue;
              }
            }
          } else if (decoded is String && looksLikeUrl(decoded)) {
            sessionUrl = decoded;
          }
        } catch (_) {
          // Not JSON; treat raw as potential URL
          if (looksLikeUrl(raw)) sessionUrl = raw;
        }

        if (sessionUrl == null || sessionUrl.isEmpty) {
          AppLog.error(
            'Missing session url in response',
            name: 'SettingRemoteApiImpl.connectAccountSession - no url',
            error: raw,
          );
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }

        return DataSuccess<String>(raw, sessionUrl);
      } else if (result is DataFailer) {
        return DataFailer<String>(
          CustomException(result.exception?.message ?? 'something_wrong'.tr()),
        );
      }
      return DataFailer<String>(
        CustomException(result.exception?.message ?? 'something_wrong'.tr()),
      );
    } catch (e, stc) {
      AppLog.error(
        '',
        name: 'SettingRemoteApiImpl.connectAccountSession - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> getWallet(String walletId) async {
    String endpoint = '/wallet/get/$walletId';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: true,
      );
      if (result is DataSuccess) {
        AppLog.info(
          'Password changed',
          name: 'SettingRemoteApi.changePassword - success',
        );
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
