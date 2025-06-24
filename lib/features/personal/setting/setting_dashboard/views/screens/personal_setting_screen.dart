import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../more_info/views/screens/personal_more_information_setting_screen.dart';
import '../../../view/setting_options/setting_notification/view/screens/personal_setting_notification_screen.dart';
import '../../../view/setting_options/security/view/screens/setting_security_screen.dart';
import '../widgets/personal_setting_tile.dart';

class PersonalSettingScreen extends StatelessWidget {
  const PersonalSettingScreen({super.key});
  static const String routeName = '/personal-setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('settings'.tr()).tr()),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.person_2_outlined,
              title: 'account'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.notifications_none,
              title: 'notification'.tr(),
              onTap: () {
                Navigator.pushNamed(
                    context, PersonalSettingNotificationScreen.routeName);
              },
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.payment,
              title: 'payment'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'privacy'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.security,
              title: 'security'.tr(),
              onTap: () {
                Navigator.pushNamed(context, SettingSecurityScreen.routeName);
              },
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.contact_page_outlined,
              title: 'contact'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.card_membership,
              title: 'membership_subscription'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.balance,
              title: 'balance'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.wallet,
              title: 'postage'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.checklist_outlined,
              title: 'order_receipts'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.shopping_bag_outlined,
              title: 'purchases'.tr(),
              onTap: () {},
            ),
          ),
          PersonalSettingTile(
            icon: Icons.info_outline,
            title: 'more_information'.tr(),
            onTap: () => Navigator.of(context)
                .pushNamed(PersonalSettingMoreInformationScreen.routeName),
          ),
        ],
      ),
    );
  }
}
