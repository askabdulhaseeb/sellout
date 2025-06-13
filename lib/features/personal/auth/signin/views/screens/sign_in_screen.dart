import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/password_textformfield.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../find_account/view/screens/find_account_screen.dart';
import '../../../signup/views/screens/signup_screen.dart';
import '../providers/signin_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    final SigninProvider authPro =
        Provider.of<SigninProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<SigninProvider>(
            builder: (BuildContext context, SigninProvider authPro, _) {
          return Form(
            key: authPro.signInFormKey,
            child: AutofillGroup(
              child: Column(
                children: <Widget>[
                  const SellOutTitle(),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    controller: authPro.email,
                    labelText: 'email'.tr(),
                    hint: 'Ex: username@mail.com',
                    autoFocus: true,
                    autofillHints: const <String>[AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) => AppValidator.email(value),
                  ),
                  PasswordTextFormField(controller: authPro.password),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          AppNavigator.pushNamed(FindAccountScreen.routeName),
                      child: Text(
                        'forgot_password',
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ).tr(),
                    ),
                  ),
                  const SizedBox(
                    height: 400,
                  )
                ],
              ),
            ),
          );
        }),
      ),
      bottomSheet: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 150,
        child: Column(
          children: [
            CustomElevatedButton(
              padding: const EdgeInsets.all(0),
              title: 'dont_have_account'.tr(),
              textStyle: TextTheme.of(context).bodyMedium,
              isLoading: false,
              bgColor: Colors.transparent,
              border: null,
              onTap: () async =>
                  await AppNavigator.pushNamed(SignupScreen.routeName),
            ),
            CustomElevatedButton(
              title: 'login'.tr(),
              isLoading: authPro.isLoading,
              onTap: () async => await authPro.signIn(),
            ),
          ],
        ),
      ),
    );
  }
}
