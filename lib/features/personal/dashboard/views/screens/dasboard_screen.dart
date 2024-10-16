import 'package:flutter/material.dart';

import '../../../../../routes/app_linking.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../auth/signin/views/screens/sign_in_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? currentUser = LocalAuth.currentUser;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Current User - ${currentUser?.email}'),
            currentUser == null
                ? TextButton(
                    onPressed: () =>
                        AppNavigator.pushNamed(SignInScreen.routeName),
                    child: const Text('Signin'),
                  )
                : TextButton(
                    onPressed: () => LocalAuth().signout(),
                    child: const Text('Logout'),
                  ),
          ],
        ),
      ),
    );
  }
}
