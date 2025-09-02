import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../terms&policies/chnage_password_screen.dart';
import '../bottomsheets/login_activity_bottomsheet.dart';
import '../bottomsheets/two_factor_bottomsheet.dart';

class SettingSecurityScreen extends StatelessWidget {
  const SettingSecurityScreen({super.key});
  static const String routeName = 'setting-security';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleKey: 'security'),
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
          Text(
            'setting_security_header'.tr(),
            style: TextTheme.of(context).titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'setting_security_subheader'.tr(),
            style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: ColorScheme.of(context).outline,
                  letterSpacing: 0.25,
                ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          _SecurityTile(
              title: 'email'.tr(),
              subtitle: 'check_email_is_correct'.tr(),
              onTap: () => _showEmailBottomSheet(context)),
          const Divider(),
          _SecurityTile(
            title: 'password'.tr(),
            subtitle: 'protect_with_stronger_password'.tr(),
            onTap: () {
              AppNavigator.pushNamed(ChangePasswordScreen.routeName);
            },
          ),
          const Divider(),
          _SecurityTile(
            title: 'two_step_verification'.tr(),
            subtitle: 'verify_with_4_digit_code'.tr(),
            onTap: () {
              const TwoFactorAuthBottomSheet();
            },
          ),
          const Divider(),
          _SecurityTile(
            title: 'login_activity'.tr(),
            subtitle: 'review_logged_in_devices'.tr(),
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                useSafeArea: true,
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const LoginActivityScreen(),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        title: Text(
          title,
          style: TextTheme.of(context).bodyMedium,
        ),
        subtitle: Text(
          subtitle,
          style: TextTheme.of(context).bodySmall?.copyWith(
                color: ColorScheme.of(context).outline,
                letterSpacing: 0.25,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Theme.of(context).scaffoldBackgroundColor);
  }
}

void _showEmailBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.email_outlined,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              LocalAuth.currentUser?.email ?? 'na'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                  onTap: () => Navigator.pop(context),
                  isLoading: false,
                  title: 'close'.tr()),
            ),
          ],
        ),
      );
    },
  );
}
