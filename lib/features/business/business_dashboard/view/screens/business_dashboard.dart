import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../personal/chats/chat_dashboard/views/screens/chat_dashboard_screen.dart';
import '../../../../personal/listing/start_listing/views/screens/start_listing_screen.dart';
import '../../../business_page/views/screens/Business_profile_screen.dart';
import '../../providers/business_botttom_nav_provider.dart';
import 'business_dashboard_appointment.dart';
import 'business_dashboard_checkout.dart';
import 'businesss_dashboard_orders.dart';

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
      const BusinessDashboardOrders(),
      const BusinessDashboardAppointment(),
      const BusinessDashboardCheckout(),
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
