import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sockets/socket_service.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../../services/get_it.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../data/sources/local/local_auth.dart';
import '../../domain/params/device_details.dart';
import '../../domain/params/login_params.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/resend_twofactor_code.dart';
import '../../domain/usecase/verify_two_factor_usecsae.dart';
import '../../domain/params/two_factor_params.dart';
import '../screens/verify_two_factor_screen.dart';

class SigninProvider extends ChangeNotifier {
  SigninProvider(this.loginUsecase, this.verifyTwoFactorUseCase,
      this.resendTwoFactorUseCase);

  final LoginUsecase loginUsecase;
  final VerifyTwoFactorUseCase verifyTwoFactorUseCase;
  final ResendTwoFactorUseCase resendTwoFactorUseCase;

  //
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController(
    text: kDebugMode ? 'ahmershurahbeeljan@gmail.com' : '',
  );
  //'hammadafzaal06@gmail.com'
  final TextEditingController password = TextEditingController(
    text: kDebugMode ? 'Shurahbeel_69' : '',
  );
//'Hammad@786'
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String sessionKey = '';
  String twoFACode = '';

  void setSessonKey(String value) {
    sessionKey = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }
    isLoading = true;
    try {
      final DataState<bool> result = await loginUsecase(
        LoginParams(
          email: email.text,
          password: password.text,
        ),
      );
      if (result is DataSuccess<bool>) {
        debugPrint('Signin Ready');
        final Map<String, dynamic> jsonMap = jsonDecode(result.data ?? '');
        if (jsonMap['require_2fa'] == true) {
          setSessonKey(jsonMap['session_key']);
          AppNavigator.pushNamed(VerifyTwoFactorScreen.routeName);
        } else if (LocalAuth.uid == null) {
        } else {
          final SocketService socketService = SocketService(locator());
          socketService.connect();
          isLoading = false;
          await AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName,
            (_) => false,
          );
        }
      } else {
        debugPrint('Signin Error in Provider');
        AppLog.error(
          'Signin Error in Provider',
          name: 'SigninProvider.signIn - Else',
          error: result,
        );
        // Show error message
      }
    } catch (e) {
      debugPrint(e.toString());
      AppLog.error(e.toString(),
          name: 'SigninProvider.signIn - Catch', error: e);
    }
    isLoading = false;
  }

  Future<void> verifyTwoFactorAuth() async {
    isLoading = true;
    try {
      final DataState<bool> result = await verifyTwoFactorUseCase(
          TwoFactorParams(code: twoFACode, sessionKey: sessionKey));
      if (result is DataSuccess<bool>) {
        debugPrint('two factor authentication Ready');
        final Map<String, dynamic> jsonMap = jsonDecode(result.data ?? '');
        if (jsonMap['require_2fa'] == true) {
          AppNavigator.pushNamed(VerifyTwoFactorScreen.routeName);
        } else {
          final SocketService socketService = SocketService(locator());
          socketService.connect();
          isLoading = false;
          await AppNavigator.pushNamedAndRemoveUntil(
            DashboardScreen.routeName,
            (_) => false,
          );
        }
      } else {
        debugPrint('two factor authentication Error in Provider');
        AppLog.error(
          'two factor authentication Error in Provider',
          name: 'SigninProvider.verifyTwoFactorAuth - Else',
          error: result,
        );
        // Show error message
      }
    } catch (e) {
      debugPrint(e.toString());
      AppLog.error(e.toString(),
          name: 'SigninProvider.verifyTwoFactorAuth - Catch', error: e);
    }
    isLoading = false;
    return;
  }

  Future<void> resendCode() async {
    isLoading = true;

    try {
      TwoFactorParams params = TwoFactorParams(
          deviceId: await DeviceInfoUtil.getDeviceId(), sessionKey: sessionKey);
      debugPrint(params.resendCodeMap().toString());
      final DataState<bool> result = await resendTwoFactorUseCase(params);
      if (result is DataSuccess<bool>) {
        final Map<String, dynamic> jsonMap = jsonDecode(result.data ?? '');
        setSessonKey(jsonMap['session_key']);
        AppLog.info(
          'Sent Code successfully in Provider',
          name: 'SigninProvider.resendCode - if',
        );
      } else {
        debugPrint('ResendCode Error in Provider');
        AppLog.error(
          'resendCode Error in Provider',
          name: 'SigninProvider.resendCode - Else',
          error: result,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      AppLog.error(e.toString(),
          name: 'SigninProvider.resendCode - Catch', error: e);
    }
    isLoading = false;
    return;
  }
}
