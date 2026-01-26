import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/domain/usecase/logout_usecase.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../setting_options/terms&policies/about_us_screen.dart';
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
          // PersonalSettingTile(
          //   icon: AppStrings.selloutPrivacyPolicyIcon,
          //   title: 'privacy_policy'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(PrivacyPolicyScreen.routeName);
          //   },
          // ),
          // PersonalSettingTile(
          //   icon: AppStrings.selloutTermsConditionIcon,
          //   title: 'terms_and_conditions'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(TermsOfServiceScreen.routeName);
          //   },
          // ),
          // PersonalSettingTile(
          //   icon: AppStrings.selloutCookiesPolicyIcon,
          //   title: 'cookies_policy'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(CookiesPolicyScreen.routeName);
          //   },
          // ),
          // PersonalSettingTile(
          //   icon: AppStrings.selloutSupportPersonIcon,
          //   title: 'acceptable_use_policy'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(AcceptableUsePolicyScreen.routeName);
          //   },
          // ),
          // PersonalSettingTile(
          //   icon: AppStrings.selloutSupportPersonIcon,
          //   title: 'dispute_resolution_procedure'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(DisputeResolutionScreen.routeName);
          //   },
          // ),
          // PersonalSettingTile(
          //   icon: AppStrings.selloutCommunityGuidlinesIcon,
          //   title: 'community_standards'.tr(),
          //   onTap: () {
          //     AppNavigator.pushNamed(CommunityStandardsScreen.routeName);
          //   },
          // ),
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
          // InDevMode(
          //   child: PersonalSettingTile(
          //     icon: AppStrings.selloutDeleteAccountSettingIcon,
          //     title: 'deactivate_account'.tr(),
          //     onTap: () {},
          //   ),
          // ),
          PersonalSettingTile(
            icon: AppStrings.selloutDeleteAccountSettingIcon,
            title: 'delete_account'.tr(),
            onTap: () {
              AppNavigator.pushNamed('/account/deactivation-deletion');
            },
          ),
          PersonalSettingTile(
            icon: AppStrings.selloutLogoutIcon,
            iconColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            displayTrailingIcon: false,
            title: 'logout'.tr(),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'are_you_sure'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    content: Text('do_you_want_to_logout'.tr()),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'cancel'.tr(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'logout'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () async {
                          final NavigatorState navigator = Navigator.of(
                            context,
                          );
                          final DataState<bool> result =
                              await locator<LogoutUsecase>().call(null);

                          if (result is DataSuccess) {
                            AppNavigator.pushNamedAndRemoveUntil(
                              DashboardScreen.routeName,
                              (_) => false,
                            );
                          } else {
                            navigator.pop();
                            if (context.mounted) {
                              AppSnackBar.error(
                                context,
                                'something_wrong'.tr(),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
