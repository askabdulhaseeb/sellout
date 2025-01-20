import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../functions/app_log.dart';

class AppValidator {
  static String? email(String? value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? '')) {
      return 'Email is Invalid';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value?.trim().length ?? 0) < 6 && !kDebugMode) {
      return 'Password should be greater then 6 digits';
    }
    return null;
  }

  static String? isEmpty(String? value) {
    return (value?.isEmpty ?? true) ? 'Field could not be empty' : null;
  }

  static String? lessThenDigits(String? value, int digits) {
    return ((value?.length ?? 0) < digits)
        ? 'Enter more then $digits characters'
        : null;
  }

  static String? greaterThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? 0.0) > compairWith)
        ? null
        : 'New input must be greater then $compairWith';
  }

  static String? lessThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? (compairWith + 1)) < compairWith)
        ? null
        : 'New input must be Less then $compairWith';
  }

  static String? confirmPassword(String first, String second) {
    return first.trim() == second.trim() && first.isNotEmpty
        ? null
        : 'Password & Confirm Password must be same';
  }

  static String? customRegExp(String formate, String? value,
      {String? message}) {
    try {
      if (formate.isEmpty) return null;
      if (!RegExp(r'$formate').hasMatch(value ?? '')) {
        return message ??
            (kDebugMode ? 'Invlide $value' : 'invalid_value'.tr());
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'AppValidator.customRegExp - $value',
        error: e,
      );
    }
    return null;
  }

  static String? retaunNull(String? value) => null;
}
