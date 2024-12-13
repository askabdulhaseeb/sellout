import 'package:flutter/foundation.dart';

import '../../../../../../core/sources/api_call.dart';
import '../models/current_user_model.dart';
import 'local/local_auth.dart';

abstract interface class SigninRemoteSource {
  Future<DataState<bool>> signin(String email, String password);
  Future<DataState<bool>> forgotPassword(String email);
}

class SigninRemoteSourceImpl implements SigninRemoteSource {
  @override
  Future<DataState<bool>> signin(String email, String password) async {
    try {
      final DataState<bool> responce = await ApiCall<bool>().call(
        endpoint: 'userAuth/login',
        requestType: ApiRequestType.post,
        body: json.encode(<String, String>{
          'email': email,
          'password': password,
        }),
        isAuth: false,
      );
      if (responce is DataSuccess<bool>) {
        debugPrint('Signin Success in Remote Source');
        final CurrentUserModel currentUser =
            CurrentUserModel.fromRawJson(responce.data ?? '');
        await LocalAuth().signin(currentUser);
        return responce;
      } else {
        debugPrint('Signin Faile in Remote Source');
        return DataFailer<bool>(CustomException('Signin Failed'));
      }
    } catch (e) {
      debugPrint('Signin Catch in Remote Source - $e');
      return DataFailer<bool>(CustomException('Signin Failed: $e'));
    }
  }

  @override
  Future<DataState<bool>> forgotPassword(String email) async {
    try {
      // Forgot Password
    } catch (e) {
      debugPrint('Forget Password Catch in Remote Source - $e');
      return DataFailer<bool>(CustomException('Forget Password Failed: $e'));
    }
    return DataFailer<bool>(CustomException('Forget Password Failed'));
  }
}
