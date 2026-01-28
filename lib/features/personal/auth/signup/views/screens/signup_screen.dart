import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/text_display/sellout_title.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../enums/signup_page_type.dart';
import '../providers/signup_provider.dart';
import '../widgets/signup_page_progress_bar_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = '/sign-up';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SignupProvider>(context, listen: false).reset();
  }

  @override
  Widget build(BuildContext context) {
    final SignupProvider pro =
        Provider.of<SignupProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const SellOutTitle(),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back_rounded),
          onPressed: () => pro.onBack(context),
        ),
        actions: <Widget>[
          Consumer<SignupProvider>(
            builder:
                (BuildContext context, SignupProvider pro, Widget? child) =>
                    Column(
              children: <Widget>[
                if (pro.currentPage == SignupPageType.photoVerification ||
                    pro.currentPage == SignupPageType.dateOfBirth ||
                    pro.currentPage == SignupPageType.location)
                  TextButton(
                    onPressed: () => Navigator.of(context).canPop()
                        ? AppNavigator.pushNamed(DashboardScreen.routeName)
                        : Provider.of<PersonalBottomNavProvider>(context,
                                listen: false)
                            .setCurrentTab(PersonalBottomNavBarType.home),
                    child: const Text('skip').tr(),
                  ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<SignupProvider>(
          builder: (BuildContext context, SignupProvider pro, _) {
            return Column(
              children: <Widget>[
                const SignupPageProgressBarWidget(),
                const SizedBox(height: 16),
                Expanded(child: pro.displayedPage()),
              ],
            );
          },
        ),
      ),
    );
  }
}
