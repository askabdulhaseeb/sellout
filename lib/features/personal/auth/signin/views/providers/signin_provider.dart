import 'dart:developer';

import 'package:flutter/material.dart';

class SigninProvider extends ChangeNotifier {
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
      // TODO: Implement sign in logic
    } catch (e) {
      log(e.toString());
    }
    isLoading = false;
  }

  Future<void> forgotPassword() async {
    isLoading = true;
    try {} catch (e) {
      log(e.toString());
    }
    isLoading = false;
  }
}
