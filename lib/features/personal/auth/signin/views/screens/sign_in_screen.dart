import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dasboard_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () => AppNavigator.pushNamed(DashboardScreen.routeName),
            child: const Text('skip').tr(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Sign In'),
      ),
    );
  }
}
