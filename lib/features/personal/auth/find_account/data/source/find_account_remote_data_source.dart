import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../view/params/new_password_params.dart';
import '../../view/params/verify_pin_params.dart';

abstract interface class FindAccountRemoteDataSource {
  Future<DataState<Map<String, dynamic>>> findAccount(String email);
  Future<DataState<String>> sendEmailForOtp(String email);
  Future<DataState<String>> newPassword(NewPasswordParams params);
  Future<DataState<bool>> verifyOtp(VerifyPinParams params);
}

class FindAccountRemoteDataSourceimpl implements FindAccountRemoteDataSource {
  @override
  Future<DataState<Map<String, dynamic>>> findAccount(String email) async {
    try {
      final DataState<String> response = await ApiCall<String>().call(
          endpoint: '/noAuth/exist?email=${email.trim()}',
          requestType: ApiRequestType.get,
          isAuth: false);
      if (response is DataSuccess) {
        if (response.data != null) {
          try {
            final Map<String, dynamic> jsonData =
                jsonDecode(response.data as String);
            return DataSuccess(response.data!, jsonData);
          } catch (e) {
            return DataFailer<Map<String, dynamic>>(
                CustomException('Invalid JSON format'));
          }
        } else {
          AppLog.error('something_wrong'.tr(),
              name: 'FindAccountRemote.findAccount - else');
          return DataFailer<Map<String, dynamic>>(
              CustomException('Response data is null'));
        }
      }
      // Handle API failure
      else if (response is DataFailer) {
        AppLog.error(
          response.exception?.message ?? 'something_wrong'.tr(),
          name: 'FindAccountRemote.findAccount - else',
        );
        return DataFailer<Map<String, dynamic>>(
            CustomException('API Call Failed: ${response.exception?.message}'));
      } else {
        return DataFailer<Map<String, dynamic>>(
            CustomException('Unexpected response type'));
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: 'FindAccountRemote.findAccount - catch - $e');
      return DataFailer<Map<String, dynamic>>(
          CustomException('Find Account Failed: $e'));
    }
  }

  @override
  Future<DataState<String>> sendEmailForOtp(String email) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().call(
          endpoint: '/userAuth/forget',
          requestType: ApiRequestType.post,
          body: jsonEncode(<String, String>{'value': email}),
          isAuth: false);
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        if (str.isEmpty) {
          return DataFailer<String>(CustomException(
            response.exception?.message ?? 'something_wrong'.tr(),
          ));
        }
        final dynamic data = json.decode(str);
        final String entity = data['uid'].toString();
        return DataSuccess<String>(entity, entity);
      } else {
        AppLog.error(response.data ?? 'something_wrong'.tr(),
            name: 'FindAccountRemote.sendEmialForOtp - else');
        return DataFailer<String>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> verifyOtp(VerifyPinParams params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/verify/${params.uid}',
        requestType: ApiRequestType.post,
        body: jsonEncode(params.tomap()),
        isAuth: true,
      );
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        // final dynamic data = json.decode(str);
        // print('new user id: ${data['message']} - $data');
        return DataSuccess<bool>(str, true);
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: 'FindAccountRemote.verifyOtp - else');
        return DataFailer<bool>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: 'FindAccountRemote.verifyOtp - catch');
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> newPassword(NewPasswordParams params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/forget/password',
        requestType: ApiRequestType.post,
        isAuth: false,
        body: jsonEncode(params.toMap()),
      );
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        if (str.isEmpty) {
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(str);
        final String entity = data['httpStatusCode'].toString();
        return DataSuccess<String>(str, entity);
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: 'FindAccountRemote.newpassword - else');
        return DataFailer<String>(CustomException(
          response.exception?.message ?? 'something_wrong'.tr(),
        ));
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: 'FindAccountRemote.newpasswored - catch');
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
