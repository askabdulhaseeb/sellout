import 'dart:developer';

import 'package:flutter/material.dart';

import '../features/personal/add/listing_form/views/screens/add_listing_form_screen.dart';
import '../features/personal/auth/signin/views/screens/sign_in_screen.dart';
import '../features/personal/auth/signup/views/screens/signup_screen.dart';
import '../features/personal/dashboard/views/screens/dasboard_screen.dart';

class AppRoutes {
  static const String baseURL = 'https://tanafos-6baeb.web.app';
  static String fromUriToRouteName(Uri? uri) {
    log('Starting URI Search.... $uri - Path: ${uri?.path}');
    if (uri == null) return DashboardScreen.routeName;
    if (uri.origin == baseURL && uri.path.isEmpty && uri.query.isEmpty) {
      return DashboardScreen.routeName;
    }
    log('New Path is: ${uri.path}');
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
  };
}
