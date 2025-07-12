import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../auth/welcome_screen/view/screens/welcome_screen.dart';
import '../../../marketplace/views/screens/marketplace_screen.dart';
import '../../../listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../post/feed/views/screens/home_screen.dart';
import '../../../user/profiles/views/screens/profile_screen.dart';
import '../../../services/views/screens/services_screen.dart';
import '../providers/personal_bottom_nav_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: LocalAuth.uidNotifier,
      builder: (BuildContext context, String? uid, _) {
        // final bool isLoggedIn = LocalAuth.uid != null;

        Widget protectedScreen(Widget screen) {
          if (LocalAuth.currentUser?.otpVerified != true) {
            return const WelcomeScreen();
          } else {
            return screen;
          }
        }

        final List<Widget> screens = <Widget>[
          const HomeScreen(),
          const MarketPlaceScreen(),
          protectedScreen(const ServicesScreen()),
          protectedScreen(const StartListingScreen()),
          protectedScreen(const ChatDashboardScreen()),
          protectedScreen(const ProfileScreen()),
        ];

        return Scaffold(
          body: Consumer<PersonalBottomNavProvider>(
            builder:
                (BuildContext context, PersonalBottomNavProvider navPro, _) {
              return IndexedStack(
                index: navPro.currentTabIndex,
                children: screens,
              );
            },
          ),
        );
      },
    );
  }
}
