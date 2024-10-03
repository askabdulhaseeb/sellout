import 'dart:developer';

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
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
        await AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName,
          (_) => false,
        );
      } else {
        // Show error message
      }
    } catch (e) {
      log(e.toString());
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
