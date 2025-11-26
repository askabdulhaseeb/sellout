import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../signin/views/screens/sign_in_screen.dart';
import '../../../signup/views/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).canPop()
                ? AppNavigator.pushNamed(DashboardScreen.routeName)
                : Provider.of<PersonalBottomNavProvider>(context, listen: false)
                    .setCurrentTab(PersonalBottomNavBarType.home),
            child: const Text('skip').tr(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
            ),
            Container(
                padding: const EdgeInsets.all(30),
                height: 200,
                width: 200,
                child: Image.asset(AppStrings.selloutLogo)),
            const SellOutTitle(size: 35),
            Text(
              'Sellout_welcome_description'.tr(),
              style: TextTheme.of(context).titleMedium?.copyWith(
                  fontSize: 18,
                  color:
                      ColorScheme.of(context).onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400),
              maxLines: 4,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomElevatedButton(
              title: 'login'.tr(),
              textStyle: TextTheme.of(context)
                  .bodyLarge
                  ?.copyWith(color: ColorScheme.of(context).onPrimary),
              isLoading: false,
              onTap: () async =>
                  await AppNavigator.pushNamed(SignInScreen.routeName),
            ),
            CustomElevatedButton(
              title: 'create_account'.tr(),
              textStyle: TextTheme.of(context)
                  .bodyLarge
                  ?.copyWith(color: ColorScheme.of(context).onSurface),
              isLoading: false,
              bgColor: Colors.transparent,
              border: Border.all(color: Theme.of(context).dividerColor),
              onTap: () async =>
                  await AppNavigator.pushNamed(SignupScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
