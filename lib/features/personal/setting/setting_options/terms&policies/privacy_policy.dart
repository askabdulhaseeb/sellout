import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const String routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('privacy_policy_title'.tr()), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text('privacy_policy_content'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorScheme.of(context)
                      .onSurface
                      .withValues(alpha: 0.4))),
        ),
      ),
    );
  }
}
