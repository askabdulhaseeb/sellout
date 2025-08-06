import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../setting_options/buyer_orders/screens/personal_setting_buyer_order_screen.dart';
import '../../../setting_options/privacy_setting/screen/privacy_screen.dart';
import 'personal_more_information_setting_screen.dart';
import '../../../setting_options/setting_notification/screens/personal_setting_notification_screen.dart';
import '../../../setting_options/security/screens/setting_security_screen.dart';
import '../widgets/personal_setting_tile.dart';
import '../../../setting_options/account_edit/screens/personal_setting_account.dart';

class PersonalSettingScreen extends StatelessWidget {
  const PersonalSettingScreen({super.key});
  static const String routeName = '/personal-setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('settings'.tr(),
                style: TextTheme.of(context)
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500))
            .tr(),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          PersonalSettingTile(
            icon: Icons.person_2_outlined,
            title: 'account'.tr(),
            onTap: () {
              AppNavigator.pushNamed(AccountSettingsScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: Icons.notifications_none,
            title: 'notification'.tr(),
            onTap: () {
              Navigator.pushNamed(
                  context, PersonalSettingNotificationScreen.routeName);
            },
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: Icons.payment,
              title: 'payment'.tr(),
              onTap: () {},
            ),
          ),
          PersonalSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'privacy'.tr(),
            onTap: () {
              Navigator.pushNamed(
                  context, PersonalPrivacySettingScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: Icons.security,
            title: 'security'.tr(),
            onTap: () {
              AppNavigator.pushNamed(SettingSecurityScreen.routeName);
            },
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
              onTap: () {
                // AppNavigator.pushNamed(BalanceScreen.routeName);
              },
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
              title: 'your_orders'.tr(),
              onTap: () => Navigator.of(context)
                  .pushNamed(PersonalSettingBuyerOrderScreen.routeName),
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
