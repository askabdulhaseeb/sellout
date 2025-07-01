import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../terms&policies/chnage_password_screen.dart';
import 'edit_setting_account_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});
  static const String routeName = '/setting-account';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget settingTile({
      required String label,
      required String value,
      bool isVerified = false,
      Widget? trailing,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label.tr(),
              style:
                  textTheme.labelMedium?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    value,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                if (isVerified)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'verified'.tr(),
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (trailing != null) trailing,
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text('account_settings_title'.tr(), style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EditAccountSettingScreen.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'edit_account_setting'.tr(),
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 30),
          settingTile(label: 'full_name', value: 'Zubair Hussain'),
          settingTile(
              label: 'email_address',
              value: 'zubair@gmail.com',
              isVerified: true),
          settingTile(
              label: 'phone_number',
              value: '+447 (***) ***23',
              isVerified: true),
          settingTile(label: 'gender', value: 'Male'),
          settingTile(label: 'birthday', value: '12/06/1991'),
          settingTile(label: 'language', value: 'English (Default)'),
          settingTile(label: 'country', value: 'United Kingdom'),
          settingTile(
            label: 'password',
            value: '************',
            trailing: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ChangePasswordScreen.routeName);
              },
              child: Text(
                'change_password'.tr(),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.secondary,
                  decorationColor: colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
