import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../signin/data/sources/local/local_auth.dart';
import '../../views/params/signup_basic_info_params.dart';
import '../../views/params/signup_send_opt_params.dart';
import '../../views/params/signup_update_user_info_params.dart';

abstract interface class SignupApi {
  Future<DataState<String>> signupBasicInfo(SignupBasicInfoParams params);
  Future<DataState<String>> signupSendOTP(SignupOptParams params);
  Future<DataState<bool>> signupVerifyOTP(SignupOptParams params);
  Future<DataState<bool>> signupUpdateUser(SignupUpdateUserInfoParams params);
}

class SignupApiImpl implements SignupApi {
  @override
  Future<DataState<String>> signupBasicInfo(
    SignupBasicInfoParams params,
  ) async {
    try {
      //
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/create',
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
        isAuth: false,
      );
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        if (str.isEmpty) {
          AppLog.error(
            'Empty response from signupBasicInfo: $str',
            name: 'SignupApiImpl.signupBasicInfo - DataSuccess if',
          );
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(str);
        final String entity = data['item']['user_id'].toString();
        print('new user id: $entity - $data');
        return DataSuccess<String>(str, entity);
      } else {
        AppLog.error(
          'Error response from signupBasicInfo: ${response.exception?.message}',
          name: 'SignupApiImpl.signupBasicInfo - DataSuccess else',
        );
        return DataFailer<String>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      AppLog.error(
        'Error from signupBasicInfo: $e',
        name: 'SignupApiImpl.signupBasicInfo - catch',
        error: e,
      );
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> signupSendOTP(SignupOptParams params) async {
    try {
      //
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/send/otp/${params.uid}',
        requestType: ApiRequestType.post,
        isAuth: false,
      );
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        if (str.isEmpty) {
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(str);
        final String entity = data['result']['Attributes']['otp'].toString();
        return DataSuccess<String>(str, entity);
      } else {
        return DataFailer<String>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> signupVerifyOTP(SignupOptParams params) async {
    try {
      //
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/verify/${params.uid}',
        requestType: ApiRequestType.post,
        body: json.encode(params.toVarifyMap()),
        isAuth: false,
      );
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        // final dynamic data = json.decode(str);
        // print('new user id: ${data['message']} - $data');
        return DataSuccess<bool>(str, true);
      } else {
        return DataFailer<bool>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> signupUpdateUser(
      SignupUpdateUserInfoParams params) async {
    try {
      //
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: 'user/update/${LocalAuth.uid}',
        requestType: ApiRequestType.patch,
        body: json.encode(params.toMap()),
        isAuth: true,
      );
      if (response is DataFailer) {
        AppLog.error(
          '${response.exception?.message}',
          name: 'SignupApiImpl.signupUpdateUser - DataFailer',
          error: response.exception,
        );
      }
      return response;
    } catch (e) {
      AppLog.error(
        'Error from signupUpdateUser: $e',
        name: 'SignupApiImpl.signupUpdateUser - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
