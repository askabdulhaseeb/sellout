import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});
  static const String routeName = '/setting-account';
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget settingTile(String title, String value,
        {bool isVerified = false, Widget? trailing}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style:
                  textTheme.labelMedium?.copyWith(color: colorScheme.outline)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(value,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
              ),
              if (isVerified)
                Text(
                  'Verified',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Account settings', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Edit Account Setting',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.primary)),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
          const SizedBox(height: 24),
          settingTile('Full Name', 'Zubair Hussain'),
          settingTile('Email address', 'zubair@gmail.com', isVerified: true),
          settingTile('Phone Number', '+447 (***) ***23', isVerified: true),
          settingTile('Gender', 'Male'),
          settingTile('Birthday', '12/06/1991'),
          settingTile('Language', 'English (Default)'),
          settingTile('Country', 'United Kingdom'),
          settingTile(
            'Password',
            '************',
            trailing: TextButton(
              onPressed: () {},
              child: Text(
                'Change Password',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
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
