import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/password_textformfield.dart';
import '../../../../../../../core/widgets/phone_number_input_field.dart';
import '../../providers/signup_provider.dart';

class SignupBasicInfoPage extends StatelessWidget {
  const SignupBasicInfoPage({super.key});
  static const String routeName = '/signup-basic-info';

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (BuildContext context, SignupProvider pro, _) {
        return ListView(
          children: <Widget>[
            CustomTextFormField(
              controller: pro.name,
              autoFocus: true,
              showSuffixIcon: true,
              hint: 'Ex. John Snow',
              labelText: 'full_name'.tr(),
              validator: (String? value) =>
                  AppValidator.lessThenDigits(value, 3),
            ),
            CustomTextFormField(
              controller: pro.username,
              hint: 'Ex. john_snow',
              labelText: 'username'.tr(),
              showSuffixIcon: true,
              validator: (String? value) =>
                  AppValidator.lessThenDigits(value, 3),
            ),
            const PhoneNumberInputField(),
            CustomTextFormField(
              controller: pro.email,
              hint: 'Ex. username@host.com',
              labelText: 'email'.tr(),
              showSuffixIcon: true,
              validator: (String? value) => AppValidator.email(value),
            ),
            PasswordTextFormField(
              controller: pro.password,
              labelText: 'password'.tr(),
              textInputAction: TextInputAction.next,
              validator: (String? value) => AppValidator.password(value),
            ),
            PasswordTextFormField(
              controller: pro.password,
              labelText: 'confirm_password'.tr(),
              textInputAction: TextInputAction.done,
              validator: (String? value) => AppValidator.confirmPassword(
                  pro.password.text, pro.confirmPassword.text),
              onFieldSubmitted: (String p0) {},
            ),
            CustomElevatedButton(
              title: 'next'.tr(),
              isLoading: false,
              onTap: () => pro.onNext(),
            ),
          ],
        );
      },
    );
  }
}
