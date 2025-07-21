import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../auth/signin/views/screens/sign_in_screen.dart';
import '../../../listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../marketplace/views/screens/marketplace_screen.dart';
import '../../../post/feed/views/screens/home_screen.dart';
import '../../../user/profiles/views/screens/profile_screen.dart';
import '../../../services/views/screens/services_screen.dart';
import '../providers/personal_bottom_nav_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? uid = LocalAuth.currentUser;
    AppLog.info('Current User ID: ${uid?.userID}');
    // Check if the user is a regular user or business user
    final List<Widget> screens = <Widget>[
      const HomeScreen(),
      const MarketPlaceScreen(),
      const ServicesScreen(),
      uid == null ? const SignInScreen() : const StartListingScreen(),
      uid == null ? const SignInScreen() : const ChatDashboardScreen(),
      uid == null ? const SignInScreen() : const ProfileScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<PersonalBottomNavProvider>(
        builder: (BuildContext context, PersonalBottomNavProvider navPro, _) {
          return screens[navPro.currentTabIndex];
        },
      ),
    );
  }
}
