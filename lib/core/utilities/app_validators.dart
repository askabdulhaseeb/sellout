import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../functions/app_log.dart';

class AppValidator {
  static String? email(String? value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? '')) {
      return 'invalid_value'.tr(args: ['email']);
    }
    return null;
  }

  static String? password(String? value) {
    final String input = value?.trim() ?? '';

    if (input.isEmpty) {
      return 'password_empty'.tr();
    }

    if (input.length < 6) {
      return 'six_characters_atleast'.tr();
    }

    final bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(input);
    final bool hasDigit = RegExp(r'\d').hasMatch(input);
    // Require at least one special character (not letter or digit)
    final bool hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(input);

    if (!hasLetter || !hasDigit || !hasSpecial) {
      return 'letter_digit_combination'.tr();
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
        ? 'enter_more_than_characters'.tr(args: [digits.toString()])
        : null;
  }

  static String? greaterThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? 0.0) > compairWith)
        ? null
        : 'greater_than'.tr(args: [compairWith.toString()]);
  }

  static String? lessThen(String? input, double compairWith) {
    return ((double.tryParse(input ?? '0') ?? (compairWith + 1)) < compairWith)
        ? null
        : 'less_than'.tr(args: [compairWith.toString()]);
  }

  static String? confirmPassword(String first, String second) {
    return first.trim() == second.trim() && first.isNotEmpty
        ? null
        : 'passwords_must_match'.tr();
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
