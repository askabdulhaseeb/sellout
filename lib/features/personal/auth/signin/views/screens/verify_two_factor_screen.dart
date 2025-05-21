import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_pin_input_field.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/signin_provider.dart';

class VerifyTwoFactorScreen extends StatelessWidget {
  const VerifyTwoFactorScreen({super.key});
  static const String routeName = '/verify-2fa';

  @override
  Widget build(BuildContext context) {
    final SigninProvider pro =
        Provider.of<SigninProvider>(context, listen: false);
    return Form(
      key: pro.verifyTwoStepAuthFormKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context)),
          elevation: 0,
          title: const SellOutTitle(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Text('enter_code_title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 4,
              ),
              Text('enter_code_description'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey)),
              const SizedBox(
                height: 12,
              ),
              Text('sent_code_to'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey)),
              Consumer<SigninProvider>(
                builder: (BuildContext context, SigninProvider pro, _) => Text(
                    pro.email.text,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              CustomPinInputField(
                pinLength: 6,
                onChanged: (String value) =>
                    context.read<SigninProvider>().twoFACode = value,
                gap: 8,
                textColor: Colors.black,
                obscureText: false,
                validator: (String? value) {
                  if (value == null || value.length != 6) {
                    return 'Please enter a valid 6-digit code';
                  }
                  return null;
                },
              ),
              TextButton(onPressed: null, child: Text('didnot_get_code'.tr())),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Consumer<SigninProvider>(
                  //   builder: (BuildContext context, SigninProvider prov, _) =>
                  //       TextButton(
                  //     onPressed: () => prov.sendemailforOtp(context),
                  //     child: Text(
                  //       'resend_code'.tr(),
                  //       style: Theme.of(context).textTheme.bodyMedium,
                  //     ),
                  //   ),
                  // ),
                  // Text(
                  //   '${context.watch<SigninProider>().resentCodeSeconds}',
                  // ),
                ],
              )
            ],
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
                  textColor: Colors.grey,
                  isLoading: false,
                  bgColor: Colors.transparent,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Consumer<SigninProvider>(
                builder: (BuildContext context, SigninProvider pro, _) =>
                    Expanded(
                  child: CustomElevatedButton(
                    margin: const EdgeInsets.all(10),
                    title: 'confirm'.tr(),
                    isLoading: pro.isLoading,
                    onTap: () {
                      if (!pro.verifyTwoStepAuthFormKey.currentState!
                          .validate()) {
                        return AppSnackBar.showSnackBar(context, '');
                      }
                      pro.verifyTwoFactorAuth();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
