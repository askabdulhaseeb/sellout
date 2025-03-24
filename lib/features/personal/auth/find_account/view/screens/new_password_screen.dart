import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/password_textformfield.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/find_account_provider.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});
  static const String routeName = '/new-password';

  @override
  Widget build(BuildContext context) {
    return Consumer<FindAccountProvider>(
      builder: (BuildContext context, FindAccountProvider prov, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          title: const SellOutTitle(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: prov.passwordFormKey, // Use the provider's form key
            child: AutofillGroup(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text('new_password_title'.tr(),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 4,
                  ),
                  Text('create_new_password'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  Text('six_characters_atleast'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  Text('letter_digit_combination'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  PasswordTextFormField(
                    controller: prov.newPassword,
                    autofillHints: const <String>[
                      AutofillHints.email,
                      AutofillHints.telephoneNumber
                    ],
                    validator: (String? value) =>
                        AppValidator.validatePhoneOrEmail(value),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'cancel'.tr(),
                  isLoading: false,
                  bgColor: Colors.transparent,
                  textColor: Colors.grey,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'confirm'.tr(),
                  isLoading: prov.isLoading,
                  onTap: () => prov.newpassword(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
