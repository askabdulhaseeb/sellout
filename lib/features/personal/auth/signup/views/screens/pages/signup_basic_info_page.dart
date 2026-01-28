import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../core/widgets/inputs/password_textformfield.dart';
import '../../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../../core/widgets/phone_number/views/phone_number_input_field.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../setting/setting_options/legal_docs/pdf_viewer_screen.dart';
import '../../../../signin/views/screens/sign_in_screen.dart';
import '../../../domain/usecase/is_valid_usecase.dart';
import '../../params/signup_is_valid_params.dart';
import '../../providers/signup_provider.dart';

class SignupBasicInfoPage extends StatelessWidget {
  const SignupBasicInfoPage({super.key});
  static const String routeName = '/signup-basic-info';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> basicInfoFormKey = GlobalKey<FormState>();

    return Consumer<SignupProvider>(
      builder: (BuildContext context, SignupProvider pro, _) {
        return Scaffold(
          extendBody: false,
          extendBodyBehindAppBar: false,
          appBar: null,
          body: Form(
            key: basicInfoFormKey,
            child: AutofillGroup(
              child: ListView(
                children: <Widget>[
                  CustomTextFormField(
                    controller: pro.name,
                    autoFocus: true,
                    showSuffixIcon: true,
                    readOnly: pro.isLoading,
                    hint: 'Ex. John Snow',
                    labelText: 'full_name'.tr(),
                    autofillHints: const <String>[AutofillHints.name],
                    validator: (String? value) => AppValidator.isEmpty(value),
                  ),
                  SIgnUpUserNameField(controller: pro.username),
                  const SizedBox(height: 8),
                  PhoneNumberInputField(
                    initialValue: pro.phoneNumber,
                    labelText: 'phone_number'.tr(),
                    onChange: (PhoneNumberEntity? value) {
                      pro.phoneNumber = value;
                    },
                  ),
                  SignUpEmailField(controller: pro.email),
                  PasswordTextFormField(
                    controller: pro.password,
                    labelText: 'password'.tr(),
                    readOnly: pro.isLoading,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                  ),
                  PasswordTextFormField(
                    controller: pro.confirmPassword,
                    labelText: 'confirm_password'.tr(),
                    textInputAction: TextInputAction.done,
                    readOnly: pro.isLoading,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    validator: (String? value) => AppValidator.confirmPassword(
                      pro.password.text,
                      value ?? '',
                    ),
                    onFieldSubmitted: (_) => pro.onNext(context),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(text: 'already_have_an_account'.tr()),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'sign_in'.tr(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                              context,
                              SignInScreen.routeName,
                            ),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomElevatedButton(
                    title: 'next'.tr(),
                    isLoading: pro.isLoading,
                    onTap: () {
                      if (!(basicInfoFormKey.currentState?.validate() ??
                          false)) {
                        debugPrint('basic info not validated');
                        return;
                      }
                      pro.onNext(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(text: 'by_registering_you_accept'.tr()),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'customer_agreement_conditions'.tr(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                              MaterialPageRoute<PdfViewerScreen>(
                                builder: (_) => PdfViewerScreen(
                                  title: 'customer_agreement_conditions',
                                  assetPath: AppStrings
                                      .termsAndConditionsUserAgreement,
                                ),
                              ),
                            ),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: 'and'.tr()),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'privacy_policy'.tr(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                              MaterialPageRoute<PdfViewerScreen>(
                                builder: (_) => PdfViewerScreen(
                                  title: 'privacy_policy',
                                  assetPath: AppStrings.privacyPolicy,
                                ),
                              ),
                            ),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignUpEmailField extends StatefulWidget {
  const SignUpEmailField({required this.controller, super.key});
  final TextEditingController controller;
  @override
  State<SignUpEmailField> createState() => _SignUpEmailFieldState();
}

class _SignUpEmailFieldState extends State<SignUpEmailField> {
  bool? isExist;
  bool isLoading = false;
  Timer? _debounce;
  String? validationError;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged() {
    // Reset states when user starts typing
    setState(() {
      validationError = null;
      isExist = null;
    });

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final String value = widget.controller.text.trim();

      // Check for format validation first
      final String? formatError = AppValidator.email(value);
      if (value.isEmpty || formatError != null) {
        setState(() {
          validationError = formatError;
          isExist = null;
          isLoading = false;
        });
        return;
      }

      setState(() => isLoading = true);

      try {
        final DataState<bool> result = await IsValidUsecase(
          locator(),
        ).call(SignupIsValidParams(email: value));

        setState(() {
          // If result.entity is true, email exists (is taken)
          // If result.entity is false, email doesn't exist (available)
          // If result.entity is null, there was an error
          isExist = result.entity ?? true; // Default to true (exists) if null
          isLoading = false;

          // Set validation error if email exists
          if (isExist == true) {
            validationError = 'email_already_used'.tr();
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          isExist = null;
          validationError = 'validation_error_try_again'.tr();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String value = widget.controller.text.trim();
    final bool hasFormatError = AppValidator.email(value) != null;

    Widget? suffixIcon;

    if (isLoading) {
      suffixIcon = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (value.isNotEmpty &&
        hasFormatError == false &&
        isExist == false) {
      suffixIcon = const Icon(Icons.check_circle, color: Colors.green);
    } else if (value.isNotEmpty && isExist == true) {
      suffixIcon = const Icon(Icons.error, color: Colors.red);
    }

    return CustomTextFormField(
      controller: widget.controller,
      hint: 'Ex. username@host.com',
      labelText: 'email'.tr(),
      showSuffixIcon: true,
      autofillHints: const <String>[AutofillHints.email],
      // errorText: validationError,
      validator: (String? val) {
        final String? formatError = AppValidator.email(val);
        if (formatError != null) return formatError;

        // If API check shows email exists
        if (isExist == true) {
          return 'email_already_used'.tr();
        }

        return null;
      },
      suffixIcon: suffixIcon,
    );
  }
}

class SIgnUpUserNameField extends StatefulWidget {
  const SIgnUpUserNameField({required this.controller, super.key});
  final TextEditingController controller;
  @override
  State<SIgnUpUserNameField> createState() => _SIgnUpUserNameFieldState();
}

class _SIgnUpUserNameFieldState extends State<SIgnUpUserNameField> {
  bool? isExist;
  bool isLoading = false;
  Timer? _debounce;
  String? validationError;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged() {
    // Reset states when user starts typing
    setState(() {
      validationError = null;
      isExist = null;
    });

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final String value = widget.controller.text.trim();

      if (value.isEmpty) {
        setState(() {
          validationError = null;
          isExist = null;
          isLoading = false;
        });
        return;
      }

      // Basic validation (you might want to add more)
      if (value.length < 3) {
        setState(() {
          validationError = 'username_too_short'.tr();
          isExist = null;
          isLoading = false;
        });
        return;
      }

      setState(() => isLoading = true);

      try {
        final DataState<bool> result = await IsValidUsecase(
          locator(),
        ).call(SignupIsValidParams(username: value));

        setState(() {
          // If result.entity is true, username exists (is taken)
          // If result.entity is false, username doesn't exist (available)
          // If result.entity is null, there was an error
          isExist = result.entity ?? true; // Default to true (exists) if null
          isLoading = false;

          // Set validation error if username exists
          if (isExist == true) {
            validationError = 'username_already_used'.tr();
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          isExist = null;
          validationError = 'validation_error_try_again'.tr();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String value = widget.controller.text.trim();

    Widget? suffixIcon;

    if (isLoading) {
      suffixIcon = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (value.isNotEmpty && value.length >= 3 && isExist == false) {
      suffixIcon = const Icon(Icons.check_circle, color: Colors.green);
    } else if (value.isNotEmpty && isExist == true) {
      suffixIcon = const Icon(Icons.error, color: Colors.red);
    }

    return CustomTextFormField(
      controller: widget.controller,
      hint: 'Ex. john_snow',
      labelText: 'username'.tr(),
      showSuffixIcon: true,
      autofillHints: const <String>[AutofillHints.username],
      // error: validationError,
      validator: (String? val) {
        final String trimmedVal = val?.trim() ?? '';

        // Basic validation
        if (trimmedVal.isEmpty) {
          return 'username_required'.tr();
        }

        if (trimmedVal.length < 3) {
          return 'username_too_short'.tr();
        }

        // If API check shows username exists
        if (isExist == true) {
          return 'username_already_used'.tr();
        }

        return null;
      },
      suffixIcon: suffixIcon,
    );
  }
}
