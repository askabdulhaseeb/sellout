import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../../views/params/two_factor_params.dart';
import '../models/current_user_model.dart';
import 'local/local_auth.dart';

abstract interface class SigninRemoteSource {
  Future<DataState<bool>> signin(String email, String password);
  Future<DataState<bool>> verifyTwoFactorAuth(TwoFactorParams params);
}

class SigninRemoteSourceImpl implements SigninRemoteSource {
  @override
  Future<DataState<bool>> signin(String email, String password) async {
    try {
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: 'userAuth/login',
        requestType: ApiRequestType.post,
        body: json.encode(<String, String>{
          'email': email.trim(),
          'password': password.trim(),
        }),
        isConnectType: true,
        isAuth: false,
      );
      if (responce is DataSuccess<bool>) {
        debugPrint('Signin Success in Remote Source');
        final Map<String, dynamic> jsonMap = jsonDecode(responce.data ?? '');
        if (jsonMap['require_2fa'] == true) {
          AppLog.info('require_2fa', name: 'SignInRemoteSourceImpl - if');
          return DataSuccess<bool>(responce.data ?? '', true);
        } else {
          await HiveDB.signout();
          final CurrentUserModel currentUser =
              CurrentUserModel.fromRawJson(responce.data ?? '');
          await LocalAuth().signin(currentUser);
          return responce;
        }
      } else {
        debugPrint('Signin Failed in Remote Source');
        return DataFailer<bool>(CustomException('Signin Failed'));
      }
    } catch (e, stc) {
      AppLog.error(e.toString(), name: 'SignInRemoteSourceImpl - catch $stc');
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
}
