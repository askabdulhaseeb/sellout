import 'dart:developer';

import 'package:flutter/material.dart';

import '../features/auth/signin/views/screens/sign_in_screen.dart';
import '../features/dashboard/views/screens/sign_in_screen.dart';

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
      case '':
      case '/':
      case '/overview':
        return DashboardScreen.routeName;
      case SignInScreen.routeName:
        return SignInScreen.routeName;
      default:
        return SignInScreen.routeName;
    }
  }

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    DashboardScreen.routeName: (_) => const DashboardScreen(),
    SignInScreen.routeName: (_) => const SignInScreen(),
  };
}
