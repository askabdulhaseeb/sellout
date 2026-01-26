import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../../domain/params/login_params.dart';
import '../../domain/params/refresh_token_params.dart';
import '../../domain/params/two_factor_params.dart';
import '../models/current_user_model.dart';
import 'local/local_auth.dart';

abstract interface class SigninRemoteSource {
  Future<DataState<bool>> signin(LoginParams params);
  Future<DataState<String>> refreshToken(RefreshTokenParams params);
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params);
  Future<DataState<bool>> resendTwoFactorCode(TwoFactorParams params);
  Future<DataState<bool>> logout();
}

class SigninRemoteSourceImpl implements SigninRemoteSource {
  @override
  Future<DataState<bool>> signin(LoginParams params) async {
    try {
      final Map<String, dynamic> bodyMap = await params.toMap();
      final String bodyJson = json.encode(bodyMap);
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: 'userAuth/login',
        requestType: ApiRequestType.post,
        body: bodyJson,
        isConnectType: false,
        isAuth: false,
      );
      if (responce is DataSuccess<bool>) {
        debugPrint('Signin Success in Remote Source');
        final Map<String, dynamic> jsonMap = jsonDecode(responce.data ?? '');
        if (jsonMap['require_2fa'] == true) {
          AppLog.info(
            'require_2fa',
            name: 'SignInRemoteSourceImpl.signin - if',
          );
          return DataSuccess<bool>(responce.data ?? '', true);
        } else {
          await HiveDB.signout();
          final CurrentUserModel currentUser = CurrentUserModel.fromRawJson(
            responce.data ?? '',
          );

          if (currentUser.logindetail.role != 'founder') {
            await LocalAuth().signin(currentUser);
          }
          return responce;
        }
      } else {
        AppLog.error(
          'Signin Failed in Remote Source',
          name: 'SignInRemoteSourceImpl.signin - else',
          error: responce.exception?.message ?? 'something_wrong'.tr(),
        );
        return DataFailer<bool>(
          responce.exception ?? CustomException('signin failed'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        'signIn error',
        name: 'SignInRemoteSourceImpl.signin - catch ',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException('Signin Failed: $e'));
    }
  }

  @override
  Future<DataState<String>> refreshToken(RefreshTokenParams params) async {
    try {
      final DataState<String> response = await ApiCall<String>().call(
        endpoint: '/userAuth/refresh',
        requestType: ApiRequestType.post,
        body: json.encode(params.toJson()),
        isConnectType: true,
        isAuth: false,
      );

      if (response is DataSuccess<String>) {
        final Map<String, dynamic> jsonMap =
            (response.data != null && response.data!.isNotEmpty)
            ? jsonDecode(response.data!) as Map<String, dynamic>
            : <String, dynamic>{};
        if (jsonMap.isNotEmpty) {
          await LocalAuth.updateToken(jsonMap['token']?.toString());
        }
        return response;
      }

      AppLog.error(
        response.exception?.message ?? 'something_wrong'.tr(),
        name: 'SignInRemoteSourceImpl.refreshToken - else',
        error: response.exception?.reason,
      );
      return DataFailer<String>(
        response.exception ?? CustomException('refresh_token_failed'),
      );
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'SignInRemoteSourceImpl.refreshToken - catch',
        stackTrace: stc,
      );
      return DataFailer<String>(CustomException('refresh_token_failed: $e'));
    }
  }

  @override
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params) async {
    try {
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: '/userAuth/2FA/verify',
        requestType: ApiRequestType.post,
        body: json.encode(params.toJson()),
        isAuth: false,
        isConnectType: true,
      );
      debugPrint(params.toJson().toString());
      if (responce is DataSuccess<bool>) {
        debugPrint('verifyTwoFactorAuth Success in Remote Source');
        await HiveDB.signout();
        final CurrentUserModel currentUser = CurrentUserModel.fromRawJson(
          responce.data ?? '',
        );
        await LocalAuth().signin(currentUser);
        return responce;
      } else {
        AppLog.error(
          responce.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignInRemoteSourceImpl.verifyTwoFactorAuth - else',
          error: responce.exception?.reason ?? '',
        );
        return DataFailer<bool>(
          CustomException('two step verification Failed'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'SignInRemoteSourceImpl.verifyTwoFactorAuth - catch',
        stackTrace: stc,
      );
      return DataFailer<bool>(
        CustomException('two step verification Failed: $e'),
      );
    }
  }

  @override
  Future<DataState<bool>> resendTwoFactorCode(TwoFactorParams params) async {
    try {
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: '/userAuth/2FA/resend',
        requestType: ApiRequestType.post,
        body: json.encode(params.resendCodeMap()),
        isConnectType: true,
        isAuth: false,
      );

      if (responce is DataSuccess<bool>) {
        return responce;
      } else {
        AppLog.error(
          responce.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignInRemoteSourceImpl.resendTwoFactorCode - else}',
          error: responce.exception?.reason ?? '',
        );
        return DataFailer<bool>(
          CustomException(
            responce.exception?.message ?? 'something_wrong'.tr(),
          ),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'SignInRemoteSourceImpl.resendTwoFactorCode - catch',
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException('Resend code failed: $e'));
    }
  }

  @override
  Future<DataState<bool>> logout() async {
    try {
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: '/user/logout',
        requestType: ApiRequestType.post,
      );

      // Always clear local data regardless of API result
      // This ensures the user is logged out even if server is unreachable
      // HiveDB.signout() calls LocalAuth().signout() which:
      // 1. Clears SecureAuthStorage (tokens, userId)
      // 2. Clears LocalAuth Hive box
      // 3. Sets uidNotifier.value = null (triggers socket disconnect via listener)
      // Additionally, HiveDB.signout() clears all other feature Hive boxes
      await HiveDB.signout();

      if (responce is DataSuccess) {
        return responce;
      } else {
        // Log error but still return success since local cleanup was done
        AppLog.error(
          responce.exception?.message ?? 'something_wrong'.tr(),
          name:
              'SignInRemoteSourceImpl.logout - API failed but local cleanup done',
          error: responce.exception?.reason ?? '',
        );
        // Return success anyway since local state is cleared
        return DataSuccess<bool>('', true);
      }
    } catch (e, stc) {
      // Even if exception occurs, try to clean up local data
      AppLog.error(
        e.toString(),
        name: 'SignInRemoteSourceImpl.logout - catch',
        stackTrace: stc,
      );
      try {
        await HiveDB.signout();
        // Return success since local cleanup was done
        return DataSuccess<bool>('', true);
      } catch (cleanupError) {
        AppLog.error(
          'Failed to cleanup local data: $cleanupError',
          name: 'SignInRemoteSourceImpl.logout - cleanup catch',
        );
        return DataFailer<bool>(CustomException('Logout failed: $e'));
      }
    }
  }
}
