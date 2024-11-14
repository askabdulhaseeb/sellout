import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../dashboard/views/screens/dasboard_screen.dart';
import '../../../setting_dashboard/views/widgets/personal_setting_tile.dart';

class PersonalSettingMoreInformationScreen extends StatelessWidget {
  const PersonalSettingMoreInformationScreen({super.key});
  static const String routeName = '/personal-more-information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('more-information').tr(),
      ),
      body: ListView(
        children: <Widget>[
          PersonalSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'privacy-policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.text_format_sharp,
            title: 'terms-and-conditions'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.cookie,
            title: 'cookies-policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.lock_person_outlined,
            title: 'acceptable-use-policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.display_settings_rounded,
            title: 'dispute-resolution-procedure'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.groups_2_outlined,
            title: 'community-standards'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.timelapse_sharp,
            title: 'time-away'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.support_agent,
            title: 'support'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.info_outline,
            title: 'about'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.no_accounts,
            title: 'deactivate-account'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.delete_outline_outlined,
            title: 'delete-account'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.logout,
            iconColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            displayTrailingIcon: false,
            title: 'logout'.tr(),
            onTap: () async {
              await LocalAuth().signout();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                DashboardScreen.routeName,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
