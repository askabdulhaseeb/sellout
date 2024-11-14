import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../more_info/views/screens/personal_more_information_setting_screen.dart';
import '../widgets/personal_setting_tile.dart';

class PersonalSettingScreen extends StatelessWidget {
  const PersonalSettingScreen({super.key});
  static const String routeName = '/personal-setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('peronsal-settings').tr()),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          PersonalSettingTile(
            icon: Icons.person_2_outlined,
            title: 'account'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.notifications_none,
            title: 'notification'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.payment,
            title: 'payment'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'privacy'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.security,
            title: 'security'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.contact_page_outlined,
            title: 'contact'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.card_membership,
            title: 'membership-subscription'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.balance,
            title: 'balance'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.wallet,
            title: 'postage'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.checklist_outlined,
            title: 'order-receipts'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.shopping_bag_outlined,
            title: 'purchases'.tr(),
            onTap: () {},
          ),
          PersonalSettingTile(
            icon: Icons.info_outline,
            title: 'more-information'.tr(),
            onTap: () => Navigator.of(context)
                .pushNamed(PersonalSettingMoreInformationScreen.routeName),
          ),
        ],
      ),
    );
  }
}
