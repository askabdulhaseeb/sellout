import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../explore/views/screens/explore_screen.dart';
import '../../../home/views/screens/home_screen.dart';
import '../../../user/views/screens/profile_screen.dart';
import '../../../services/views/screens/services_screen.dart';
import '../providers/personal_bottom_nav_provider.dart';

const List<Widget> _screens = <Widget>[
  HomeScreen(),
  ExploreScreen(),
  ServicesScreen(),
  StartListingScreen(),
  ChatDashboardScreen(),
  ProfileScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PersonalBottomNavProvider>(
        builder: (BuildContext context, PersonalBottomNavProvider navPro, _) {
          return _screens[navPro.currentTabIndex];
        },
      ),
    );
  }
}
