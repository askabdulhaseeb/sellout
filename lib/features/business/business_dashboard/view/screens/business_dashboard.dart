import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../personal/chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../../personal/explore/views/screens/explore_screen.dart';
import '../../../../personal/listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../../personal/post/feed/views/screens/home_screen.dart';
import '../../../../personal/services/views/screens/services_screen.dart';
import '../../../business_page/views/screens/Business_profile_screen.dart';
import '../../providers/business_botttom_nav_provider.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});
  static const String routeName = '/business_dashboard';

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? uid = LocalAuth.currentUser;
    AppLog.info('Current Business ID: ${uid?.businessID}');
    final List<Widget> myscreens = <Widget>[
    BusinessProfileScreen(
        businessID: uid?.businessID ?? '',
      ),
      const StartListingScreen(),
      const ChatDashboardScreen(),
      const HomeScreen(),
      const ExploreScreen(),
      const ServicesScreen(),
    ];
    return Scaffold(
      body: Consumer<BusinessBottomNavProvider>(
        builder: (BuildContext context, BusinessBottomNavProvider pro, _) {
          return myscreens[pro.currentTabIndex];
        },
      ),
    );
  }
}
