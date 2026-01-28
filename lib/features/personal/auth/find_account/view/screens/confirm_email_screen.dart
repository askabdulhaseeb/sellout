import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../core/widgets/text_display/sellout_title.dart';
import '../providers/find_account_provider.dart';

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen({super.key});
  static const String routeName = '/confirm-email';

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text('confirm_email_title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(
              height: 8,
            ),
            Text('confirm_email_description'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(
              height: 8,
            ),
            Consumer<FindAccountProvider>(
              builder: (BuildContext context, FindAccountProvider pro, _) =>
                  Text(pro.email ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 100,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // InDevMode(
            //     child: CustomElevatedButton(
            //   margin: const EdgeInsets.all(10),
            //   title: 'try_another_way'.tr(),
            //   isLoading: false,
            //   textColor: ColorScheme.of(context).onSurface,
            //   bgColor: ColorScheme.of(context).surface,
            //   border: Border.all(color: Theme.of(context).dividerColor),
            //   onTap: () =>
            //        AppNavigator.pushNamed( SendCodeScreen.routeName),
            // )),
            Consumer<FindAccountProvider>(
              builder: (BuildContext context, FindAccountProvider pro, _) =>
                  CustomElevatedButton(
                      margin: const EdgeInsets.all(10),
                      title: 'confirm'.tr(),
                      isLoading: pro.isLoading,
                      onTap: () => pro.sendemailforOtp(context)),
            ),
          ],
        ),
      ),
    );
  }
}
