import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../view/params/forgot_params.dart';
import '../../view/params/new_password_params.dart';

abstract interface class FindAccountRemoteDataSource {
  Future<DataState<Map<String, dynamic>>> findAccount(String email);
  Future<DataState<String>> sendEmailForOtp(OtpResponseParams params);
  Future<DataState<String>> newPassword(NewPasswordParams params);
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
            return DataSuccess<Map<String, dynamic>>(
              response.data ?? '',
              jsonData,
            );
          } catch (e) {
            debugPrint('❌ JSON Decode Error: $e');
            return DataFailer<Map<String, dynamic>>(
                CustomException('Invalid JSON format'));
          }
        } else {
          AppLog.error(
            'something_wrong'.tr(),
            name: 'FindAccountRemoteDataSourceimpl.findAccount - else',
          );
          return DataFailer<Map<String, dynamic>>(
              CustomException('Response data is null'));
        }
      }
      // Handle API failure
      else if (response is DataFailer) {
        AppLog.error(
          response.exception?.message ?? 'something_wrong'.tr(),
        );
        return DataFailer<Map<String, dynamic>>(
            CustomException('API Call Failed: ${response.exception?.message}'));
      } else {
        AppLog.error(response.exception?.message ?? 'something_wrong'.tr(),
            name: '❌ Unexpected response type: ${response.runtimeType}');
        return DataFailer<Map<String, dynamic>>(
            CustomException('Unexpected response type'));
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: '❌ Find Account Catch in Remote Source - $e');
      return DataFailer<Map<String, dynamic>>(
          CustomException('Find Account Failed: $e'));
    }
  }

  @override
  Future<DataState<String>> sendEmailForOtp(OtpResponseParams params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().call(
          endpoint: '/userAuth/forget',
          requestType: ApiRequestType.post,
          body: jsonEncode(<String, String>{'value': params.value ?? ''}),
          isAuth: false);
      if (response is DataSuccess<bool>) {
        final String str = response.data ?? '';
        if (str.isEmpty) {
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(str);
        final String entity = data['result']['Attributes']['otp'].toString();
        final String uid = data['uid'].toString();
        return DataSuccess<String>(uid, entity);
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
  Future<DataState<String>> newPassword(NewPasswordParams params) async {
    try {
      final DataState<bool> response = await ApiCall<bool>().call(
        endpoint: '/userAuth/forget/password',
        requestType: ApiRequestType.post,
        isAuth: false,
        body: jsonEncode(params.toMap()),
      );
      debugPrint('look ${params.password}');
      debugPrint('look${params.uid}');
      if (response is DataSuccess<bool>) {
        AppLog.info('✅ API Response: ${jsonEncode(response.data)}');
        final String str = response.data ?? '';
        if (str.isEmpty) {
          return DataFailer<String>(CustomException('something_wrong'.tr()));
        }
        final dynamic data = json.decode(str);
        final String entity = data['httpStatusCode'].toString();
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
}
