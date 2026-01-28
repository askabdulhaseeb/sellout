import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../core/widgets/inputs/custom_pin_input_field.dart';
import '../../../../../../core/widgets/text_display/sellout_title.dart';
import '../providers/find_account_provider.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({super.key});
  static const String routeName = '/enter-code';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SellOutTitle(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10, width: double.infinity),
            Text('enter_code_title'.tr(), style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'enter_code_description'.tr(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'sent_code_to'.tr(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 4),
            Consumer<FindAccountProvider>(
              builder: (_, FindAccountProvider provider, __) =>
                  Text(provider.email ?? '', style: textTheme.bodySmall),
            ),
            const SizedBox(height: 20),
            CustomPinInputField(
              fontSize: 14,
              pinLength: 6,
              onChanged: (String value) {
                context.read<FindAccountProvider>().pin.text = value;
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: null,
              child: Text(
                'didnot_get_code'.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Consumer<FindAccountProvider>(
              builder: (_, FindAccountProvider provider, __) {
                final bool canResend = provider.resentCodeSeconds == 0;
                final int minutes = provider.resentCodeSeconds ~/ 60;
                final int seconds = provider.resentCodeSeconds % 60;
                return canResend
                    ? InkWell(
                        onTap: () => provider.sendemailforOtp(context),
                        child: Text(
                          'resend_code'.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${'resend_code'.tr()}: ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: ColorScheme.of(
                                context,
                              ).onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                          Text(
                            '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorScheme.of(context).outline,
                            ),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 100,
        color: theme.scaffoldBackgroundColor,
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
                border: Border.all(color: theme.dividerColor),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Consumer<FindAccountProvider>(
              builder: (_, FindAccountProvider provider, __) => Expanded(
                child: CustomElevatedButton(
                  margin: const EdgeInsets.all(10),
                  title: 'confirm'.tr(),
                  isLoading: provider.isLoading,
                  onTap: () => provider.verifyOtp(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
