import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackBar {
  // Animation styles
  static const AnimationStyle _defaultAnimationStyle = AnimationStyle.fade;
  static const Duration _defaultDuration = Duration(seconds: 4);
  static const Duration _validationDuration = Duration(seconds: 5);

  // VALIDATION STYLES - Enhanced with icons and better colors
  static SnackBarStyle get validationSuccessStyle => SnackBarStyle(
        backgroundColor: Colors.green.shade600,
        icon: Icons.verified,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static SnackBarStyle get validationErrorStyle => SnackBarStyle(
        backgroundColor: Colors.red.shade600,
        icon: Icons.error_outline,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static SnackBarStyle get validationWarningStyle => SnackBarStyle(
        backgroundColor: Colors.orange.shade600,
        icon: Icons.warning_amber,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.orange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static SnackBarStyle get validationInfoStyle => SnackBarStyle(
        backgroundColor: Colors.blue.shade600,
        icon: Icons.info_outline,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static SnackBarStyle get validationRequiredStyle => SnackBarStyle(
        backgroundColor: Colors.deepOrange.shade600,
        icon: Icons.priority_high,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade600, Colors.deepOrange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static SnackBarStyle get validationLimitStyle => SnackBarStyle(
        backgroundColor: Colors.purple.shade600,
        icon: Icons.limit,
        iconColor: Colors.white,
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.purple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  // FIELD-SPECIFIC VALIDATION STYLES
  static SnackBarStyle get emailValidationStyle => SnackBarStyle(
        backgroundColor: Colors.teal.shade600,
        icon: Icons.email,
        iconColor: Colors.white,
        textColor: Colors.white,
      );

  static SnackBarStyle get passwordValidationStyle => SnackBarStyle(
        backgroundColor: Colors.indigo.shade600,
        icon: Icons.password,
        iconColor: Colors.white,
        textColor: Colors.white,
      );

  static SnackBarStyle get phoneValidationStyle => SnackBarStyle(
        backgroundColor: Colors.cyan.shade600,
        icon: Icons.phone,
        iconColor: Colors.white,
        textColor: Colors.white,
      );

  static SnackBarStyle get attachmentValidationStyle => SnackBarStyle(
        backgroundColor: Colors.amber.shade700,
        icon: Icons.attach_file,
        iconColor: Colors.white,
        textColor: Colors.white,
      );

  // VALIDATION METHODS
  static void showValidationSuccess(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
    bool showIcon = true,
    bool showProgress = false,
  }) {
    showSnackBar(
      context,
      message,
      style: validationSuccessStyle,
      duration: duration,
      showIcon: showIcon,
      showProgressBar: showProgress,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showValidationError(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
    bool showIcon = true,
    String? fieldName,
    ValidationSeverity severity = ValidationSeverity.error,
  }) {
    final styledMessage = fieldName != null ? '$fieldName: $message' : message;

    showSnackBar(
      context,
      styledMessage,
      style: _getSeverityStyle(severity),
      duration: duration,
      showIcon: showIcon,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
    );
  }

  static void showValidationWarning(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
    bool showIcon = true,
    String? suggestion,
  }) {
    final fullMessage = suggestion != null ? '$message\n$suggestion' : message;

    showSnackBar(
      context,
      fullMessage,
      style: validationWarningStyle,
      duration: duration,
      showIcon: showIcon,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showValidationRequired(
    BuildContext context,
    String fieldName, {
    Duration duration = _validationDuration,
  }) {
    showSnackBar(
      context,
      '$fieldName is required',
      style: validationRequiredStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showValidationLimit(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
    required int current,
    required int max,
  }) {
    showSnackBar(
      context,
      '$message ($current/$max)',
      style: validationLimitStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  // FIELD-SPECIFIC VALIDATION METHODS
  static void showEmailValidation(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
  }) {
    showSnackBar(
      context,
      message,
      style: emailValidationStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showPasswordValidation(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
  }) {
    showSnackBar(
      context,
      message,
      style: passwordValidationStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showPhoneValidation(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
  }) {
    showSnackBar(
      context,
      message,
      style: phoneValidationStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  static void showAttachmentValidation(
    BuildContext context,
    String message, {
    Duration duration = _validationDuration,
    bool hasAction = false,
    VoidCallback? onAction,
  }) {
    if (hasAction && onAction != null) {
      showActionSnackBar(
        context,
        message,
        actionLabel: 'FIX',
        onAction: onAction,
        style: attachmentValidationStyle,
        duration: duration,
      );
    } else {
      showSnackBar(
        context,
        message,
        style: attachmentValidationStyle,
        duration: duration,
        showIcon: true,
        borderRadius: BorderRadius.circular(16),
      );
    }
  }

  // FORM VALIDATION COMPLETE
  static void showFormValidationComplete(
    BuildContext context, {
    Duration duration = _validationDuration,
    int successCount = 0,
  }) {
    final message = successCount > 0
        ? 'Form validated successfully! ($successCount checks passed)'
        : 'Form validation completed';

    showSnackBar(
      context,
      message,
      style: validationSuccessStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
      showProgressBar: true,
    );
  }

  // MULTIPLE VALIDATION ERRORS
  static void showMultipleValidationErrors(
    BuildContext context,
    List<String> errors, {
    Duration duration = const Duration(seconds: 6),
  }) {
    final errorCount = errors.length;
    final mainMessage = errorCount == 1
        ? 'There is 1 validation error'
        : 'There are $errorCount validation errors';

    showSnackBar(
      context,
      '$mainMessage\n• ${errors.join('\n• ')}',
      style: validationErrorStyle,
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  // VALIDATION WITH COUNTER
  static void showValidationWithCounter(
    BuildContext context,
    String message,
    int current,
    int max, {
    Duration duration = _validationDuration,
    ValidationType type = ValidationType.length,
  }) {
    final percentage = (current / max * 100).toInt();
    Color color;

    if (percentage < 50) {
      color = Colors.red.shade600;
    } else if (percentage < 80) {
      color = Colors.orange.shade600;
    } else {
      color = Colors.green.shade600;
    }

    showSnackBar(
      context,
      '$message ($current/$max)',
      style: SnackBarStyle(
        backgroundColor: color,
        icon: _getValidationIcon(type),
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
      duration: duration,
      showIcon: true,
      borderRadius: BorderRadius.circular(16),
    );
  }

  // PRIVATE HELPER METHODS
  static SnackBarStyle _getSeverityStyle(ValidationSeverity severity) {
    switch (severity) {
      case ValidationSeverity.info:
        return validationInfoStyle;
      case ValidationSeverity.warning:
        return validationWarningStyle;
      case ValidationSeverity.error:
        return validationErrorStyle;
      case ValidationSeverity.critical:
        return validationRequiredStyle;
    }
  }

  static IconData _getValidationIcon(ValidationType type) {
    switch (type) {
      case ValidationType.length:
        return Icons.text_fields;
      case ValidationType.email:
        return Icons.email;
      case ValidationType.password:
        return Icons.password;
      case ValidationType.phone:
        return Icons.phone;
      case ValidationType.required:
        return Icons.flag;
      case ValidationType.format:
        return Icons.format_color_text;
      case ValidationType.attachment:
        return Icons.attach_file;
    }
  }

  // ... (Keep all the existing methods from previous implementation)

  // Main method with enhanced options (same as before but updated)
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarStyle style = const SnackBarStyle(),
    AnimationStyle animationStyle = _defaultAnimationStyle,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    bool showCloseButton = true,
    bool showIcon = true,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(12)),
    EdgeInsetsGeometry margin = const EdgeInsets.all(8),
    double elevation = 6.0,
    bool showProgressBar = false,
  }) {
    final snackBar = _buildSnackBar(
      message: message,
      style: style,
      duration: duration,
      onTap: onTap,
      showCloseButton: showCloseButton,
      showIcon: showIcon,
      borderRadius: borderRadius,
      margin: margin,
      elevation: elevation,
      showProgressBar: showProgressBar,
    );

    _showWithAnimation(context, snackBar, animationStyle);
  }

  // ... (Keep all other existing methods)

  static SnackBar _buildSnackBar({
    required String message,
    required SnackBarStyle style,
    required Duration duration,
    VoidCallback? onTap,
    bool showCloseButton = true,
    bool showIcon = true,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(12)),
    EdgeInsetsGeometry margin = const EdgeInsets.all(8),
    double elevation = 6.0,
    bool showProgressBar = false,
  }) {
    final hasMultipleLines = message.contains('\n');

    return SnackBar(
      content: Row(
        children: [
          if (showIcon && style.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                style.icon,
                color: style.iconColor,
                size: 24,
              ),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasMultipleLines)
                  ...message
                      .split('\n')
                      .map((line) => Text(
                            line,
                            style: GoogleFonts.poppins(
                              color: style.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ))
                      .toList()
                else
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      color: style.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              icon: Icon(Icons.close,
                  color: style.textColor.withOpacity(0.7), size: 20),
              onPressed: () {
                ScaffoldMessenger.of(Scaffold.maybeOf(
                        GlobalKey<ScaffoldState>().currentContext!)!)
                    .hideCurrentSnackBar();
              },
            ),
        ],
      ),
      backgroundColor: style.backgroundColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: margin,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      onVisible: () {
        if (showProgressBar) {
          // Progress indicator logic
        }
      },
    );
  }
}

// VALIDATION ENUMS AND CLASSES
enum ValidationSeverity {
  info,
  warning,
  error,
  critical,
}

enum ValidationType {
  length,
  email,
  password,
  phone,
  required,
  format,
  attachment,
}

class ValidationRule {
  final String fieldName;
  final bool isValid;
  final String message;
  final ValidationSeverity severity;

  ValidationRule({
    required this.fieldName,
    required this.isValid,
    required this.message,
    this.severity = ValidationSeverity.error,
  });
}

// Extension for validation context
extension ValidationSnackBarExtension on BuildContext {
  // Validation methods
  void showValidationError(String message, {String? fieldName}) {
    AppSnackBar.showValidationError(this, message, fieldName: fieldName);
  }

  void showValidationSuccess(String message) {
    AppSnackBar.showValidationSuccess(this, message);
  }

  void showValidationWarning(String message, {String? suggestion}) {
    AppSnackBar.showValidationWarning(this, message, suggestion: suggestion);
  }

  void showValidationRequired(String fieldName) {
    AppSnackBar.showValidationRequired(this, fieldName);
  }

  void showAttachmentValidationError(String message, {VoidCallback? onFix}) {
    AppSnackBar.showAttachmentValidation(this, message,
        hasAction: onFix != null, onAction: onFix);
  }

  void showMultipleErrors(List<String> errors) {
    AppSnackBar.showMultipleValidationErrors(this, errors);
  }
}

// Keep the existing supporting classes...
class SnackBarStyle {
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;
  final Color textColor;
  final Color? actionTextColor;
  final Gradient? gradient;

  const SnackBarStyle({
    this.backgroundColor = Colors.black87,
    this.icon,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.actionTextColor,
    this.gradient,
  });
}

enum AnimationStyle {
  slide,
  fade,
  scale,
}
