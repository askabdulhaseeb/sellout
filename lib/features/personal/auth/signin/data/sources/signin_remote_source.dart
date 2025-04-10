import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../models/current_user_model.dart';
import 'local/local_auth.dart';

abstract interface class SigninRemoteSource {
  Future<DataState<bool>> signin(String email, String password);
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
        await HiveDB.signout();
        final CurrentUserModel currentUser =
            CurrentUserModel.fromRawJson(responce.data ?? '');
        await LocalAuth().signin(currentUser);
        return responce;
      } else {
        debugPrint('Signin Failed in Remote Source');
        return DataFailer<bool>(CustomException('Signin Failed'));
      }
    } catch (e, stc) {
      AppLog.error(e.toString(), name: 'SignInRemoteSourceImpl - catch $stc');
      return DataFailer<bool>(CustomException('Signin Failed: $e'));
    }
  }
}
