import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/sellout_title.dart';
import '../../../../dashboard/views/providers/personal_bottom_nav_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final SignupProvider provider =
          Provider.of<SignupProvider>(context, listen: false);
      provider.navigateToVerify(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignupProvider provider =
        Provider.of<SignupProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const SellOutTitle(),
        leading: Column(
          children: <Widget>[
            if (provider.currentPage != SignupPageType.basicInfo)
              IconButton(
                icon: Icon(Icons.adaptive.arrow_back_rounded),
                onPressed: () =>
                    Provider.of<SignupProvider>(context, listen: false)
                        .onBack(context),
              ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Provider.of<PersonalBottomNavProvider>(context, listen: false)
                    .setCurrentTab(PersonalBottomNavBarType.home),
            child: const Text('skip').tr(),
          ),
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
                Expanded(child: pro.displayedPage())
              ],
            );
          },
        ),
      ),
    );
  }
}
