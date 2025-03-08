import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../signin/views/screens/sign_in_screen.dart';
import '../../domain/use_cases/find_account_usecase.dart';
import '../../domain/use_cases/newpassword_usecase.dart';
import '../../domain/use_cases/send_otp_usecase.dart';
import '../params/forgot_params.dart';
import '../params/new_password_params.dart';
import '../screens/confirm_email_screen.dart';
import '../screens/enter_code_screen.dart';
import '../screens/new_password_screen.dart';

class FindAccountProvider with ChangeNotifier {
  FindAccountProvider(this.findAccountUseCase, this.sendEmailForOtpUsecase,
      this.newPasswordUsecase);
  final FindAccountUsecase findAccountUseCase;
  final SendEmailForOtpUsecase sendEmailForOtpUsecase;
  final NewPasswordUsecase newPasswordUsecase;
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  final TextEditingController _phoneOrEmailController = TextEditingController();
  final GlobalKey<FormState> _findAccountformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? email;
  String? _uid;

  static const int _codeSendingTime = 60;
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

  String? _getOTP;
  set getOTP(String? value) {
    _getOTP = value;
    notifyListeners();
  }

  // Getters
  TextEditingController get phoneOrEmailController => _phoneOrEmailController;
  TextEditingController get newPassword => _newPassword;
  TextEditingController get pin => _pin;

  GlobalKey<FormState> get findAccountFormKey => _findAccountformKey;
  GlobalKey<FormState> get passwordFormKey => _passwordFormKey;
  bool get isLoading => _isLoading;
  //Loading
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Method to find account
  Future<void> findAccount(BuildContext context) async {
    if (!_findAccountformKey.currentState!.validate()) return;
    isLoading = true;

    try {
      final String phoneOrEmail = _phoneOrEmailController.text.trim();
      final DataState<Map<String, dynamic>> result =
          await findAccountUseCase(phoneOrEmail);
      // debugPrint('🔹 Provider received result: $result');
      // debugPrint('🔹 Result Type: ${result.runtimeType}');
      // debugPrint('🔹 Result Data: ${result.data}');
      if (result is DataSuccess<Map<String, dynamic>>) {
        final String? rawData = result.data;
        if (rawData != null) {
          try {
            final Map<String, dynamic> jsonData = jsonDecode(rawData);
            //  debugPrint('✅ Decoded JSON Data: $jsonData');

            if (jsonData.containsKey('email_exists')) {
              final bool isEmailExists = jsonData['email_exists'] ?? false;

              if (isEmailExists) {
                AppLog.info(
                    '🔹 Email Exists: Navigating to ConfirmEmailScreen');
                email = phoneOrEmail;
                Navigator.of(context).pushNamed(ConfirmEmailScreen.routeName);
              } else {
                AppLog.info('❌ Email does not exist');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email does not exist')),
                );
              }
            } else {
              throw Exception(
                  'Invalid API response format: Missing "email_exists" key');
            }
          } catch (e) {
            AppLog.error('❌ JSON Decode Error: $e');
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
      AppLog.error('❌ FindAccountProvider - catch Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
    }
  }

  // Method to send email for Otp
  Future<bool> sendOtp(BuildContext context) async {
    if (email == null) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return false;
    }
    isLoading = true;
    try {
      final DataState<String> result = await sendEmailForOtpUsecase(
        OtpResponseParams(value: email ?? ''),
      );
      if (result is DataSuccess) {
        getOTP = result.entity;
        uid = result.data;
        startResendCodeTimer();
        AppNavigator.pushNamed(EnterCodeScreen.routeName);
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignupProvider.sendOtp - else',
          error: result,
        );
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SignupProvider.sendOtp - catch',
        error: e,
      );
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, e.toString());
    }
    isLoading = false;
    return false;
  }

  Future<bool> verifyOtp(BuildContext context) async {
    if (_resentCodeSeconds == 0) {
      AppLog.error(
        'something_wrong',
        name: 'FindAccountProvider.verifyOtp - timer',
      );
      AppSnackBar.showSnackBar(
          context, 'OTP has expired. Please request a new one.'.tr());
      return false;
    }
    if (pin.text.isEmpty) {
      AppLog.error(
        'something_wrong',
        name: 'SignupProvider.verifyOtp - otp',
      );
      AppSnackBar.showSnackBar(context, 'otp_requirement'.tr());
      return false;
    }
    if (pin.text != _getOTP) {
      debugPrint(_getOTP);
      AppLog.error(
       'something_wrong',
        name: 'SignupProvider.verifyOtp - otp',
      );
      AppSnackBar.showSnackBar(context, 'otp_not_match'.tr());
      return false;
    }
    if (pin.text == _getOTP) {
      AppNavigator.pushNamed(NewPasswordScreen.routeName);
      return true;
    }
    try {
      ();
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SignupProvider.verifyOtp - catch',
        error: e,
      );
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, e.toString());
    }
    return false;
  }

  Future<bool> newpassword(BuildContext context) async {
    if (newPassword.text.isEmpty) {
      AppLog.error('Password is empty',
          name: 'FindAccountProvider.newpassword');
      AppSnackBar.showSnackBar(context, 'password_requirement'.tr());
      return false;
    }
    isLoading = true;
    try {
      final NewPasswordParams params = NewPasswordParams(
        uid: _uid ?? '',
        password: newPassword.text.trim(),
      );

      // Call the use case to handle the password update API call
      final DataState<String> result = await newPasswordUsecase(params);

      if (result is DataSuccess) {
        AppLog.info('✅ Password updated successfully');
        AppSnackBar.showSnackBar(context, 'Password changed successfully');
        AppNavigator.pushNamedAndRemoveUntil(
          SignInScreen.routeName,
          (_) => true,
        );
        dispose();
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'FindAccountProvider.newpassword - error',
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
    _resendCodeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resentCodeSeconds == 0) {
        timer.cancel();
      } else {
        _resentCodeSeconds--;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _phoneOrEmailController.dispose();
    _newPassword.dispose();
    _pin.dispose();
    super.dispose();
  }
}
