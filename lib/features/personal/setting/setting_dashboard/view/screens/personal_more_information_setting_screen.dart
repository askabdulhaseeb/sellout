import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/local/hive_db.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../user/profiles/views/params/about_us.dart';
import '../../../setting_options/terms&policies/acceptable_user_policy.dart';
import '../../../setting_options/terms&policies/community_standard_screeen.dart';
import '../../../setting_options/terms&policies/cookie_policy.dart';
import '../../../setting_options/terms&policies/dispute_resolution_policy.dart';
import '../../../setting_options/terms&policies/privacy_policy.dart';
import '../../../setting_options/terms&policies/terms_condition_screen.dart';
import '../../../setting_options/time_away/screens/time_away_screen.dart';
import '../widgets/personal_setting_tile.dart';

class PersonalSettingMoreInformationScreen extends StatelessWidget {
  const PersonalSettingMoreInformationScreen({super.key});
  static const String routeName = '/personal-more_information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'more_information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          PersonalSettingTile(
            icon: AppStrings.selloutPrivacyPolicyIcon,
            title: 'privacy_policy'.tr(),
            onTap: () {
              AppNavigator.pushNamed(PrivacyPolicyScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutTermsConditionIcon,
            title: 'terms_and_conditions'.tr(),
            onTap: () {
              AppNavigator.pushNamed(TermsOfServiceScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutCookiesPolicyIcon,
            title: 'cookies_policy'.tr(),
            onTap: () {
              AppNavigator.pushNamed(CookiesPolicyScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutSupportPersonIcon,
            title: 'acceptable_use_policy'.tr(),
            onTap: () {
              AppNavigator.pushNamed(AcceptableUsePolicyScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutSupportPersonIcon,
            title: 'dispute_resolution_procedure'.tr(),
            onTap: () {
              AppNavigator.pushNamed(DisputeResolutionScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutCommunityGuidlinesIcon,
            title: 'community_standards'.tr(),
            onTap: () {
              AppNavigator.pushNamed(CommunityStandardsScreen.routeName);
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutSupportPersonIcon,
            title: 'time_away'.tr(),
            onTap: () {
              AppNavigator.pushNamed(TimeAwayScreen.routeName);
            },
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutSupportPersonIcon,
              title: 'support'.tr(),
              onTap: () {},
            ),
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutAboutIcon,
            title: 'about'.tr(),
            onTap: () {
              AppNavigator.pushNamed(AboutUsScreen.routeName);
            },
          ),
          InDevMode(
            child: PersonalSettingTile(
              icon: AppStrings.selloutDeleteAccountSettingIcon,
              title: 'deactivate_account'.tr(),
              onTap: () {},
            ),
          ),
          // InDevMode(
          //   child: PersonalSettingTile(
          //     icon: Icons.delete_outline_outlined,
          //     title: 'delete_account'.tr(),
          //     onTap: () {},
          //   ),
          // ),
          PersonalSettingTile(
            icon: AppStrings.selloutLogoutIcon,
            iconColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            displayTrailingIcon: false,
            title: 'logout'.tr(),
            onTap: () async {
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
