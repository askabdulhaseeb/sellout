import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/password_textformfield.dart';
import '../../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../../core/widgets/phone_number/views/phone_number_input_field.dart';
import '../../../../signin/views/screens/sign_in_screen.dart';
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
                    validator: (String? value) =>
                        AppValidator.lessThenDigits(value, 3),
                  ),
                  CustomTextFormField(
                    controller: pro.username,
                    hint: 'Ex. john_snow',
                    labelText: 'username'.tr(),
                    showSuffixIcon: true,
                    readOnly: pro.isLoading,
                    autofillHints: const <String>[AutofillHints.username],
                    validator: (String? value) =>
                        AppValidator.lessThenDigits(value, 3),
                  ),
                  const SizedBox(height: 8),
                  PhoneNumberInputField(
                    initialValue: pro.phoneNumber,
                    labelText: 'phone_number'.tr(),
                    onChange: (PhoneNumberEntity? value) {
                      pro.phoneNumber = value;
                    },
                  ),
                  CustomTextFormField(
                    controller: pro.email,
                    hint: 'Ex. username@host.com',
                    labelText: 'email'.tr(),
                    showSuffixIcon: true,
                    readOnly: pro.isLoading,
                    autofillHints: const <String>[AutofillHints.email],
                    validator: (String? value) => AppValidator.email(value),
                  ),
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
                        pro.password.text, value ?? ''),
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
                                context, SignInScreen.routeName),
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
                            ..onTap = () => Navigator.of(context).pop(),
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
                            ..onTap = () => Navigator.of(context).pop(),
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
