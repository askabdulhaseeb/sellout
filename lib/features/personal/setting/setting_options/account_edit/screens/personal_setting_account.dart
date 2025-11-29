import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import 'edit_setting_account_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});
  static const String routeName = '/setting-account';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CurrentUserEntity? user = LocalAuth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleKey: 'account_settings_title'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, EditAccountSettingScreen.routeName),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'edit_account_setting'.tr(),
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.secondary),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _InfoTile(
            label: 'full_name'.tr(),
            value: user?.displayName ?? '-',
          ),
          _InfoTile(
            label: 'email'.tr(),
            value: user?.email ?? '-',
            isVerified: LocalAuth.currentUser?.otpVerified ?? false,
          ),
          _InfoTile(
            label: 'phone_number'.tr(),
            value: '${user?.phoneNumber}',
            isVerified: false,
          ),
          //       _InfoTile(
          //         label: 'gender'.tr(),
          //        value: user?.gender?.capitalize() ?? '-',
          //     ),
          _InfoTile(
            label: 'birthday'.tr(),
            value:
                user?.dob != null ? DateFormat.yMMMd().format(user!.dob!) : '-',
          ),
          _InfoTile(
            label: 'language'.tr(),
            value: user?.language ?? '-',
          ),
          _InfoTile(
            label: 'country'.tr(),
            value: user?.countryAlpha3 ?? '-',
          ),
        ],
      ),
    );
  }
}

// 🔒 Private reusable tile widget
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.isVerified = false,
  });

  final String label;
  final String value;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: textTheme.labelMedium
                ?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4)),
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
                    color: Colors.green.withValues(alpha: 0.1),
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
            ],
          ),
        ],
      ),
    );
  }
}
