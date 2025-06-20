import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sockets/socket_service.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../../services/get_it.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../setting_dashboard/views/widgets/personal_setting_tile.dart';

class PersonalSettingMoreInformationScreen extends StatelessWidget {
  const PersonalSettingMoreInformationScreen({super.key});
  static const String routeName = '/personal-more_information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('more_information').tr(),
      ),
      body: ListView(
        children: <Widget>[
          PersonalSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'privacy_policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.text_format_sharp,
            title: 'terms_and_conditions'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.cookie,
            title: 'cookies_policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.lock_person_outlined,
            title: 'acceptable_use_policy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.display_settings_rounded,
            title: 'dispute_resolution_procedure'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.groups_2_outlined,
            title: 'community_standards'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.timelapse_sharp,
            title: 'time_away'.tr(),
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
            title: 'deactivate_account'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.delete_outline_outlined,
            title: 'delete_account'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.logout,
            iconColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            displayTrailingIcon: false,
            title: 'logout'.tr(),
            onTap: () async {
              final SocketService socketService = SocketService(locator());
              socketService.disconnect();
              await HiveDB.signout();
              AppNavigator.pushNamedAndRemoveUntil(
                  DashboardScreen.routeName, (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
