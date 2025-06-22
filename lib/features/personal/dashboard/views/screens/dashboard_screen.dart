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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final CurrentUserEntity? uid = LocalAuth.currentUser;

    _screens = <Widget>[
      const HomeScreen(),
      const MarketPlaceScreen(),
      const ServicesScreen(),
      uid == null ? const WelcomeScreen() : const StartListingScreen(),
      uid == null ? const WelcomeScreen() : const ChatDashboardScreen(),
      uid == null ? const WelcomeScreen() : const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PersonalBottomNavProvider>(
        builder: (BuildContext context, PersonalBottomNavProvider navPro, _) {
          return IndexedStack(
            index: navPro.currentTabIndex,
            children: _screens,
          );
        },
      ),
    );
  }
}
