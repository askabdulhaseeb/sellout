import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_pin_input_field.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../providers/find_account_provider.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({super.key});
  static const String routeName = '/enter-code';

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
            Consumer<FindAccountProvider>(
              builder: (BuildContext context, FindAccountProvider pro, _) =>
                  Text(pro.email ?? '',
                      style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            CustomPinInputField(
              onChanged: (String value) {
                context.read<FindAccountProvider>().pin.text = value;
              },
              fontSize: 14,
              pinLength: 6,
            ),
            TextButton(onPressed: null, child: Text('didnot_get_code'.tr())),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Consumer<FindAccountProvider>(
                  builder:
                      (BuildContext context, FindAccountProvider prov, _) =>
                          TextButton(
                    onPressed: () => prov.sendemailforOtp(context),
                    child: Text(
                      'resend_code'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                Text(
                  '${context.watch<FindAccountProvider>().resentCodeSeconds}',
                ),
              ],
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 100,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Consumer<FindAccountProvider>(
              builder: (BuildContext context, FindAccountProvider prov, _) =>
                  Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'confirm'.tr(),
                  isLoading: prov.isLoading,
                  onTap: () async {
                    prov.verifyOtp(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
