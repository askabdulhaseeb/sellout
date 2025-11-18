import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../auth/welcome_screen/view/screens/welcome_screen.dart';
import '../../../listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../marketplace/views/screens/marketplace_screen.dart';
import '../../../post/feed/views/screens/home_screen.dart';
import '../../../user/profiles/views/screens/profile_screen.dart';
import '../../../services/services_screen/screens/services_screen.dart';
import '../providers/personal_bottom_nav_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? uid = LocalAuth.currentUser;
    final bool otpVerified = LocalAuth.currentUser?.otpVerified ?? false;
    AppLog.info('Current User ID: ${uid?.userID}');
    // Check if the user is a regular user or business user
    final List<Widget> screens = <Widget>[
      const HomeScreen(),
      const MarketPlaceScreen(),
      const ServicesScreen(),
      (uid == null && !otpVerified)
          ? const WelcomeScreen()
          : const StartListingScreen(),
      (uid == null && !otpVerified)
          ? const WelcomeScreen()
          : const ChatDashboardScreen(),
      (uid == null && !otpVerified)
          ? const WelcomeScreen()
          : const ProfileScreen(),
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
