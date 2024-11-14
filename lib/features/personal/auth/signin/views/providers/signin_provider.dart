import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dasboard_screen.dart';
import '../../domain/params/login_params.dart';
import '../../domain/usecase/forgot_password_usecase.dart';
import '../../domain/usecase/login_usecase.dart';

class SigninProvider extends ChangeNotifier {
  SigninProvider(
    this.loginUsecase,
    this.forgotPasswordUsecase,
  );

  final LoginUsecase loginUsecase;
  final ForgotPasswordUsecase forgotPasswordUsecase;

  //
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController(
    text: kDebugMode ? 'test@gmail.com' : '',
  );
  final TextEditingController password = TextEditingController(
    text: kDebugMode ? '123' : '',
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
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
        await AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName,
          (_) => false,
        );
      } else {
        debugPrint('Signin Error in Provider');
        log(
          'Signin Error in Provider',
          name: 'SigninProvider.signIn - Else',
          error: result,
        );
        // Show error message
      }
    } catch (e) {
      debugPrint(e.toString());
      log(e.toString(), name: 'SigninProvider.signIn - Catch', error: e);
    }
    isLoading = false;
  }

  Future<void> forgotPassword() async {
    isLoading = true;
    try {
      final DataState<bool> result = await forgotPasswordUsecase(email.text);
      if (result is DataSuccess<bool>) {
        // Show success message
      } else {
        // Show error message
      }
    } catch (e) {
      log(e.toString());
    }
    isLoading = false;
  }
}
