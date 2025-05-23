import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../two_factor_bottomsheet.dart';

class SettingSecurityScreen extends StatelessWidget {
  const SettingSecurityScreen({super.key});
  static const String routeName = 'setting-factor-authentication';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('security'.tr()),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          Text('setting_security_header'.tr(),
              style: TextTheme.of(context).titleMedium),
          const SizedBox(height: 4),
          Text(
            'setting_security_subheader'.tr(),
            style: TextTheme.of(context).bodyMedium?.copyWith(
                color: ColorScheme.of(context).outline, letterSpacing: 0.25),
          ),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text('email'.tr(), style: TextTheme.of(context).bodyMedium),
            subtitle: Text(
              'check_email_is_correct'.tr(),
              style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: ColorScheme.of(context).outline, letterSpacing: 0.25),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title:
                Text('password'.tr(), style: TextTheme.of(context).bodyMedium),
            subtitle: Text(
              'protect_with_stronger_password'.tr(),
              style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: ColorScheme.of(context).outline, letterSpacing: 0.25),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text('two_step_verification'.tr(),
                style: TextTheme.of(context).bodyMedium),
            subtitle: Text(
              'verify_with_4_digit_code'.tr(),
              style: TextTheme.of(context).bodySmall?.copyWith(
                  color: ColorScheme.of(context).outline, letterSpacing: 0.25),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) =>
                    const TwoFactorAuthBottomSheet(),
              );
            },
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text('login_activity'.tr(),
                style: TextTheme.of(context).bodyMedium),
            subtitle: Text(
              'review_logged_in_devices'.tr(),
              style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: ColorScheme.of(context).outline, letterSpacing: 0.25),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
        ],
      ),
    );
  }
}
