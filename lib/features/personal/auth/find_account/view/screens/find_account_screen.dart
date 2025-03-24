import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/find_account_provider.dart';

class FindAccountScreen extends StatelessWidget {
  const FindAccountScreen({super.key});
  static const String routeName = '/find-account';
  @override
  Widget build(BuildContext context) {
    final FindAccountProvider pro =
        Provider.of<FindAccountProvider>(context, listen: false);

    return Scaffold(
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: pro.findAccountFormKey, // Use the provider's form key
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                'find_account_title'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text('find_account_description'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey)),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              CustomTextFormField(
                controller: pro.phoneOrEmailController,
                hint: 'email'.tr(),
                autoFocus: true,
                autofillHints: const <String>[
                  AutofillHints.email,
                  AutofillHints.telephoneNumber
                ],
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) =>
                    AppValidator.validatePhoneOrEmail(value),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
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
              flex: 1,
              child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'confirm'.tr(),
                  isLoading: pro.isLoading,
                  onTap: () => pro.findAccount(context)),
            ),
          ],
        ),
      ),
    );
  }
}
