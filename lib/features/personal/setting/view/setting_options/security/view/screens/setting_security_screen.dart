import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../../../user/profiles/views/params/update_user_params.dart';

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
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) => const TwoFactorBottomSheet(),
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

class TwoFactorBottomSheet extends StatefulWidget {
  const TwoFactorBottomSheet({super.key});

  @override
  State<TwoFactorBottomSheet> createState() => _TwoFactorBottomSheetState();
}

class _TwoFactorBottomSheetState extends State<TwoFactorBottomSheet> {
  bool isEnabled = false;
  bool isLoading = false;
  String? errorMessage;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    fetchInitialValue().then((bool value) {
      setState(() {
        isEnabled = value;
        isInitialized = true;
      });
    });
  }

  Future<bool> fetchInitialValue() async {
    await Future<String>.delayed(const Duration(milliseconds: 300));
    return false;
  }

  Future<void> updateTwoFactorAuth(bool newValue) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final UpdateUserParams params = UpdateUserParams(
      uid: LocalAuth.uid ?? '',
      twoFactorAuth: newValue,
    );

    final DataState<String> result =
        await UpdateProfileDetailUsecase(locator()).call(params);

    if (result is DataSuccess) {
      setState(() {
        isEnabled = newValue;
        isLoading = false;
      });
      AppLog.info('✅ Two-factor authentication updated successfully');
    } else {
      setState(() {
        errorMessage = 'something_wrong'.tr();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enable 2-Step Verification',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You will receive a 4-digit code on your phone each time you log in.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('two_step_verification'.tr(),
                  style: const TextStyle(fontSize: 14)),
              isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Switch(
                      value: isEnabled,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool newValue) {
                        if (!isLoading) updateTwoFactorAuth(newValue);
                      },
                    ),
            ],
          ),
          if (errorMessage != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }
}
