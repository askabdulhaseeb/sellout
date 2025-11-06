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
    final String input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'Password cannot be empty';
    }

    if (input.length < 6) {
      return 'Password should be at least 6 characters long';
    }

    final bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(input);
    final bool hasDigit = RegExp(r'\d').hasMatch(input);
    final bool hasSymbol =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+;~`]').hasMatch(input);

    if (!hasLetter || !hasDigit || !hasSymbol) {
      return 'Use a combination of letters, digits, and symbols for a strong password';
    }

    return null;
  }

  static String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_left_empty'.tr();
    }
    return null;
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
    debugPrint('[AppValidator] pattern: $formate  rawValue: $value');
    try {
      if (formate.isEmpty) return null;
      // Normalize the input: strip common separators and whitespace so a
      // pattern expecting digits will match even if value contains spaces/dashes.
      final String raw = value ?? '';
      final String normalized = raw.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
      debugPrint('[AppValidator] normalizedValue: $normalized');

      final RegExp regex = RegExp(formate);
      if (!regex.hasMatch(normalized)) {
        return message ??
            (kDebugMode ? 'Invalid $normalized' : 'invalid_value'.tr());
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'AppValidator.customRegExp',
        error: e,
      );
      debugPrint('[AppValidator] regex error: $e\n$formate\nvalue:$value');
    }
    return null;
  }

  static String? requireSelection(bool? value, {String? message}) {
    if (value == null || value == false) {
      return message ?? 'select_dropdown'.tr();
    }
    return null;
  }

  static String? requireLocation(bool? value, {String? message}) {
    if (value == null || value == false) {
      return message ?? 'location_is_required'.tr();
    }
    return null;
  }

  static String? retaunNull(String? value) => null;
}
