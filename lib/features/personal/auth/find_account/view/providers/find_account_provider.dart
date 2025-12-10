import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../signin/views/screens/sign_in_screen.dart';
import '../../domain/use_cases/find_account_usecase.dart';
import '../../domain/use_cases/newpassword_usecase.dart';
import '../../domain/use_cases/send_otp_usecase.dart';
import '../../domain/use_cases/verify_otp_usecase.dart';
import '../params/new_password_params.dart';
import '../params/verify_pin_params.dart';
import '../screens/confirm_email_screen.dart';
import '../screens/enter_code_screen.dart';
import '../screens/new_password_screen.dart';

class FindAccountProvider with ChangeNotifier {
  FindAccountProvider(
    this.findAccountUseCase,
    this.sendEmailForOtpUsecase,
    this.newPasswordUsecase,
    this.verifyOtpUsecase,
  );
  final FindAccountUsecase findAccountUseCase;
  final SendEmailForOtpUsecase sendEmailForOtpUsecase;
  final NewPasswordUsecase newPasswordUsecase;
  final VerifyOtpUseCase verifyOtpUsecase;
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _phoneOrEmailController = TextEditingController();
  bool _isLoading = false;
  String? email;
  String? _uid;

  static const int _codeSendingTime = 300;
  int _resentCodeSeconds = _codeSendingTime;
  int get resentCodeSeconds => _resentCodeSeconds;
  set resentCodeSeconds(int value) {
    _resentCodeSeconds = value;
    notifyListeners();
  }

  Timer? _resendCodeTimer;
  Timer? get resendCodeTimer => _resendCodeTimer;
  set uid(String? value) {
    _uid = value;
  }

  // Getters
  TextEditingController get phoneOrEmailController => _phoneOrEmailController;
  TextEditingController get newPassword => _newPassword;
  TextEditingController get pin => _pin;
  bool get isLoading => _isLoading;
  //Loading
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Method to find account
  Future<void> findAccount(BuildContext context) async {
    isLoading = true;
    try {
      final String phoneOrEmail = _phoneOrEmailController.text.trim();
      final DataState<Map<String, dynamic>> result = await findAccountUseCase(
        phoneOrEmail,
      );
      if (result is DataSuccess<Map<String, dynamic>>) {
        final String? rawData = result.data;
        if (rawData != null) {
          try {
            final Map<String, dynamic> jsonData = jsonDecode(rawData);
            if (jsonData.containsKey('email_exists')) {
              final bool isEmailExists = jsonData['email_exists'] ?? false;
              if (isEmailExists) {
                email = phoneOrEmail;
                Navigator.of(context).pushNamed(ConfirmEmailScreen.routeName);
              } else {
                AppLog.error(
                  '${result.exception}',
                  name: 'FindAccountProvider.findAccount - else',
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('something_wrong'.tr())));
              }
            }
          } catch (e) {
            AppLog.error(
              'something_wrong'.tr(),
              name: 'FindAccountProvider.findAccount - catch $e',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid API response format')),
            );
          }
        } else {
          throw Exception('API response data is null');
        }
      } else if (result is DataFailer<Map<String, dynamic>>) {
        throw Exception('API Error: ${result.exception?.message}');
      } else {
        throw Exception('Unexpected response type: ${result.runtimeType}');
      }
    } catch (e) {
      AppLog.error(
        'something_wrong'.tr(),
        name: ' FindAccountProvider - catch Error: $e',
      );
    } finally {
      isLoading = false;
    }
  }

  // Method to send email for Otp

  Future<bool> sendemailforOtp(BuildContext context) async {
    if (_resendCodeTimer != null && _resendCodeTimer!.isActive) {
      return false;
    }
    isLoading = true;
    try {
      final DataState<String> result = await sendEmailForOtpUsecase(
        email ?? '',
      );

      if (result is DataSuccess) {
        uid = result.entity;
        startResendCodeTimer();
        Navigator.of(context).pushNamed(EnterCodeScreen.routeName);
        isLoading = false;
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignupProvider.sendOtp - else',
          error: result,
        );
      }
    } catch (e) {
      AppLog.error(
        'something_wrong'.tr(),
        name: 'SignupProvider.sendOtp - catch:$e',
        error: e,
      );
    }

    isLoading = false;
    return false;
  }

  Future<bool> verifyOtp(BuildContext context) async {
    if (_uid == null) {
      AppLog.error('uid_null', name: 'FindAccountProvider.verifyOtp - uid');
      AppSnackBar.showSnackBar(context, 'uid_null'.tr());
      return false;
    }
    if (pin.text.isEmpty) {
      AppLog.error(
        'something_wrong'.tr(),
        name: 'FindAccountProvider.verifyOtp - otp',
      );
      AppSnackBar.showSnackBar(context, 'otp_requirement'.tr());
      return false;
    }
    isLoading = true;
    try {
      final VerifyPinParams params = VerifyPinParams(
        uid: _uid ?? '',
        otp: pin.text,
      );
      final DataState<bool> result = await verifyOtpUsecase(params);
      if (result is DataSuccess) {
        AppNavigator.pushNamed(NewPasswordScreen.routeName);
      } else {
        AppLog.error(
          'something_wrong'.tr(),
          name: 'SignupProvider.verifyOtp - else',
          error: result,
        );
      }
    } catch (e) {
      AppLog.error(
        'something_wrong'.tr(),
        name: 'FindAccountProvider.VerifyOtp - catch $e',
      );
    }
    isLoading = false;
    return false;
  }

  Future<bool> newpassword(BuildContext context) async {
    if (newPassword.text.isEmpty) {
      AppLog.error(
        'password_empty',
        name: 'FindAccountProvider.newpassword - empty password',
      );
      AppSnackBar.showSnackBar(context, 'password_requirement'.tr());
      return false;
    }
    isLoading = true;
    try {
      final NewPasswordParams params = NewPasswordParams(
        uid: _uid ?? '',
        password: newPassword.text.trim(),
      );
      debugPrint(_uid);
      final DataState<String> result = await newPasswordUsecase(params);
      if (result is DataSuccess) {
        reset();
        AppNavigator.pushNamedAndRemoveUntil(
          SignInScreen.routeName,
          (_) => true,
        );
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'FindAccountProvider.newpassword - else',
          error: result,
        );
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'FindAccountProvider.newpassword - catch',
        error: e,
      );
      AppSnackBar.showSnackBar(context, 'An error occurred: $e');
    } finally {
      isLoading = false;
    }
    return false;
  }

  void startResendCodeTimer() {
    _isLoading = false;
    _resendCodeTimer?.cancel();
    _resentCodeSeconds = _codeSendingTime;
    _resendCodeTimer = Timer.periodic(const Duration(seconds: 1), (
      Timer timer,
    ) {
      if (_resentCodeSeconds == 0) {
        timer.cancel();
      } else {
        _resentCodeSeconds--;
      }
      notifyListeners();
    });
  }

  void reset() {
    _isLoading = false;
    _uid = null;
    email = null;
    _resentCodeSeconds = _codeSendingTime;
    _resendCodeTimer?.cancel();
    _phoneOrEmailController.clear();
    _pin.clear();
    _newPassword.clear();

    notifyListeners();
  }
}
