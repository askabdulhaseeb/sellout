import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_validators.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/find_account_provider.dart';

class FindAccountScreen extends StatelessWidget {
  const FindAccountScreen({super.key});
  static const String routeName = '/find-account';
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> findAccountformKey = GlobalKey<FormState>();
    final FindAccountProvider pro =
        Provider.of<FindAccountProvider>(context, listen: false);
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => pro.reset(),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: findAccountformKey,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorScheme.of(context)
                            .onSurface
                            .withValues(alpha: 0.6))),
                const SizedBox(
                  height: 20,
                  width: double.infinity,
                ),
                CustomTextFormField(
                  controller: pro.phoneOrEmailController,
                  hint: 'email'.tr(),
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) => AppValidator.email(value),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BottomAppBar(
          height: 100,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'cancel'.tr(),
                  isLoading: false,
                  textColor: ColorScheme.of(context).onSurface,
                  bgColor: ColorScheme.of(context).surface,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'confirm'.tr(),
                  isLoading: pro.isLoading,
                  onTap: () {
                    if (!findAccountformKey.currentState!.validate()) return;
                    pro.findAccount(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
