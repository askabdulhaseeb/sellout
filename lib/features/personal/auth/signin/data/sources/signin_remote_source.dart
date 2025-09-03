import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../../domain/params/login_params.dart';
import '../../domain/params/two_factor_params.dart';
import '../models/current_user_model.dart';
import 'local/local_auth.dart';

abstract interface class SigninRemoteSource {
  Future<DataState<bool>> signin(LoginParams params);
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params);
  Future<DataState<bool>> resendTwoFactorCode(TwoFactorParams params);
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
        isConnectType: true,
        isAuth: false,
      );
      if (responce is DataSuccess<bool>) {
        debugPrint('Signin Success in Remote Source');
        final Map<String, dynamic> jsonMap = jsonDecode(responce.data ?? '');
        if (jsonMap['require_2fa'] == true) {
          AppLog.info('require_2fa',
              name: 'SignInRemoteSourceImpl.signin - if');
          return DataSuccess<bool>(responce.data ?? '', true);
        } else {
          await HiveDB.signout();
          final CurrentUserModel currentUser =
              CurrentUserModel.fromRawJson(responce.data ?? '');
          if (currentUser.logindetail.role != 'founder') {
            await LocalAuth().signin(currentUser);
          }
          return responce;
        }
      } else {
        AppLog.error('Signin Failed in Remote Source',
            name: 'SignInRemoteSourceImpl.signin - else',
            error: responce.exception?.message ?? 'something_wrong'.tr());
        return DataFailer<bool>(
            responce.exception ?? CustomException('signin failed'));
      }
    } catch (e, stc) {
      AppLog.error('signIn error',
          name: 'SignInRemoteSourceImpl.signin - catch ',
          error: e,
          stackTrace: stc);
      return DataFailer<bool>(CustomException('Signin Failed: $e'));
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
          isConnectType: true);
      debugPrint(params.toJson().toString());
      if (responce is DataSuccess<bool>) {
        debugPrint('verifyTwoFactorAuth Success in Remote Source');
        await HiveDB.signout();
        final CurrentUserModel currentUser =
            CurrentUserModel.fromRawJson(responce.data ?? '');
        await LocalAuth().signin(currentUser);
        return responce;
      } else {
        AppLog.error(responce.exception?.message ?? 'something_wrong'.tr(),
            name: 'SignInRemoteSourceImpl.verifyTwoFactorAuth - else',
            error: responce.exception?.reason ?? '');
        return DataFailer<bool>(
            CustomException('two step verification Failed'));
      }
    } catch (e, stc) {
      AppLog.error(e.toString(),
          name: 'SignInRemoteSourceImpl.verifyTwoFactorAuth - catch',
          stackTrace: stc);
      return DataFailer<bool>(
          CustomException('two step verification Failed: $e'));
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
              responce.exception?.message ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'SignInRemoteSourceImpl.resendTwoFactorCode - catch',
        stackTrace: stc,
      );
      return DataFailer<bool>(
        CustomException('Resend code failed: $e'),
      );
    }
  }
}
