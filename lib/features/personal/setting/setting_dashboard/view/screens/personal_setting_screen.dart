import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../settings/views/screens/connect_bank_screen.dart';
import '../../../../order/view/screens/your_order_screen.dart';
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
            icon: AppStrings.selloutAccountSettingIcon,
            title: 'account'.tr(),
            onTap: () {
              AppNavigator.pushNamed(AccountSettingsScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutNotificationSettingIcon,
            title: 'notification'.tr(),
            onTap: () {
              Navigator.pushNamed(
                  context, PersonalSettingNotificationScreen.routeName);
            },
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutPaymentSettingIcon,
              title: 'payment'.tr(),
              onTap: () {},
            ),
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutPrivacySettingIcon,
            title: 'privacy'.tr(),
            onTap: () {
              Navigator.pushNamed(
                  context, PersonalPrivacySettingScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutSecuritySettingIcon,
            title: 'security'.tr(),
            onTap: () {
              AppNavigator.pushNamed(SettingSecurityScreen.routeName);
            },
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutContactSettingIcon,
              title: 'contact'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutMembershipSettingIcon,
              title: 'membership_subscription'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutPaymentSettingIcon,
              title: 'postage'.tr(),
              onTap: () {},
            ),
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutOrderReceiptSettingIcon,
              title: 'order_receipts'.tr(),
              onTap: () {},
            ),
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutYouorderSettingIcon,
            title: 'your_orders'.tr(),
            onTap: () =>
                Navigator.of(context).pushNamed(YourOrdersScreen.routeName),
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutMoreSettingIcon,
            title: 'connect_bank_account'.tr(),
            onTap: () =>
                Navigator.of(context).pushNamed(ConnectBankScreen.routeName),
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutMoreSettingIcon,
            title: 'more_information'.tr(),
            onTap: () => Navigator.of(context)
                .pushNamed(PersonalSettingMoreInformationScreen.routeName),
          ),
        ],
      ),
    );
  }
}
