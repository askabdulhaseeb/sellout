import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/toggles/custom_switch_list_tile.dart';
import '../../../../../../core/widgets/utils/in_dev_mode.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../setting_dashboard/view/providers/personal_setting_provider.dart';

class PersonalPrivacySettingScreen extends StatelessWidget {
  const PersonalPrivacySettingScreen({super.key});
  static const String routeName = '/privacy_settings';

  @override
  Widget build(BuildContext context) {
    final PersonalSettingProvider provider =
        Provider.of<PersonalSettingProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleKey: 'privacy_settings_title'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: <Widget>[
          CustomSwitchListTile(
            title: 'third_party_tracking'.tr(),
            subtitle: 'third_party_tracking_subtitle'.tr(),
            value: provider.thirdPartyTracking,
            onChanged: (bool value) => provider.toggleThirdPartyTracking(value),
          ),
          const Divider(),
          CustomSwitchListTile(
            title: 'personalized_content'.tr(),
            subtitle: 'personalized_content_subtitle'.tr(),
            value: provider.personalizedContent,
            onChanged: (bool value) =>
                provider.togglePersonalizedContent(value),
          ),
          const SizedBox(height: 12),
          InDevMode(
            child: ListTile(
              title: Text(
                'download_account_data'.tr(),
                style: textTheme.bodySmall,
              ),
              subtitle: Text(
                'download_account_data_subtitle'.tr(),
                style: textTheme.bodySmall?.copyWith(
                  color: ColorScheme.of(context).outline.withValues(alpha: 0.4),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
