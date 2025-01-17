import 'package:flutter/material.dart';

import '../core/functions/app_log.dart';
import '../features/business/service/views/screens/add_service_screen.dart';
import '../features/personal/cart/views/screens/personal_cart_screen.dart';
import '../features/personal/chats/chat/views/screens/chat_screen.dart';
import '../features/personal/listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../features/personal/auth/signin/views/screens/sign_in_screen.dart';
import '../features/personal/auth/signup/views/screens/signup_screen.dart';
import '../features/personal/dashboard/views/screens/dasboard_screen.dart';
import '../features/personal/post/post_detail/views/screens/post_detail_screen.dart';
import '../features/personal/setting/more_info/views/screens/personal_more_information_setting_screen.dart';
import '../features/personal/setting/setting_dashboard/views/screens/personal_setting_screen.dart';

class AppRoutes {
  static const String baseURL = 'https://selloutweb.com';
  static String fromUriToRouteName(Uri? uri) {
    AppLog.info(
      'Starting URI Search.... $uri - Path: ${uri?.path}',
      name: 'AppRoutes.fromUriToRouteName',
    );
    if (uri == null) return DashboardScreen.routeName;
    if (uri.origin == baseURL && uri.path.isEmpty && uri.query.isEmpty) {
      return DashboardScreen.routeName;
    }
    switch (uri.path) {
      // AUTH
      case SignInScreen.routeName:
        return SignInScreen.routeName;
      case SignupScreen.routeName:
        return SignupScreen.routeName;

      // DASHBOARD
      case '':
      case '/':
      case '/overview':
        return DashboardScreen.routeName;
      default:
        return SignInScreen.routeName;
    }
  }

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    // AUTH
    SignInScreen.routeName: (_) => const SignInScreen(),
    SignupScreen.routeName: (_) => const SignupScreen(),

    // DAHSBOARD
    DashboardScreen.routeName: (_) => const DashboardScreen(),
    AddListingFormScreen.routeName: (_) => const AddListingFormScreen(),
    // POST
    PostDetailScreen.routeName: (_) => const PostDetailScreen(),

    ChatScreen.routeName: (_) => const ChatScreen(),

    // CART
    PersonalCartScreen.routeName: (_) => const PersonalCartScreen(),
    // SETTINGS
    PersonalSettingScreen.routeName: (_) => const PersonalSettingScreen(),
    PersonalSettingMoreInformationScreen.routeName: (_) =>
        const PersonalSettingMoreInformationScreen(),

    // BUSSINESS
    AddServiceScreen.routeName: (_) => const AddServiceScreen(),
  };
}
