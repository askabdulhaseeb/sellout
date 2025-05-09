import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../core/functions/app_log.dart';
import 'app_routes.dart';

class AppNavigator {
  // Variables
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  static final AppLinks _appLinks = AppLinks();

  // Getters
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  Stream<Uri>? get linkSubscription => _appLinks.uriLinkStream;

  // Constructor
  void init() {
    _appLinks.uriLinkStream.listen((Uri uri) async {
      await openAppLink(uri);
    });
  }

  Future<void> openAppLink(Uri uri) async {
    final String routeName = AppRoutes.fromUriToRouteName(uri);
    AppLog.info('Moving to $routeName', name: 'AppNavigator.openAppLink');
    await pushNamed(routeName);
  }

  static Future<void> pushNamed(String routeName, {Object? arguments}) async {
    try {
      AppLog.info('New Path is: $routeName', name: 'AppNavigator.pushNamed');
      await _navigatorKey.currentState
          ?.pushNamed(routeName, arguments: arguments);
    } catch (e) {
      AppLog.error(
        'in App Navigator - pushNamed: $routeName - Error: $e',
        name: 'AppNavigator.pushNamed - catch',
        error: e,
      );
    }
  }

  static Future<void> pushNamedAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>)? predicate, {
    Object? arguments,
  }) async {
    try {
      AppLog.info(
        'New Path is: $routeName',
        name: 'AppNavigator.pushNamedAndRemoveUntil',
      );
      final Object? result =
          await _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        predicate ?? (_) => true,
        arguments: arguments,
      );
      AppLog.info(
        'Result: $result',
        name: 'AppNavigator.pushNamedAndRemoveUntil',
      );
    } catch (e) {
      AppLog.error(
        'in App Navigator - pushNamedAndRemoveUntil: $routeName - Error: $e',
        name: 'AppNavigator.pushNamedAndRemoveUntil - catch',
        error: e,
      );
    }
  }

  void dispose() {
    // _linkSubscription?.cancel();
  }

  // Singleton
  // static final MyAppLinking _instance = MyAppLinking._internal();
  // factory MyAppLinking() => _instance;
  // MyAppLinking._internal();

  // // Static methods
  // static void initAppLinking() {
  //   final MyAppLinking appLinking = MyAppLinking();
  //   appLinking.init();
  // }

  // static void disposeAppLinking() {
  //   final MyAppLinking appLinking = MyAppLinking();
  //   appLinking.dispose();
  // }

  // static void openAppLink(Uri uri) {
  //   final MyAppLinking appLinking = MyAppLinking();
  //   appLinking.openAppLink(uri);
  // }

  // static GlobalKey<NavigatorState> get navigatorKey {
  //   final MyAppLinking appLinking = MyAppLinking();
  //   return appLinking.navigatorKey;
  // }

  // static StreamSubscription<Uri>? get linkSubscription {
  //   final MyAppLinking appLinking = MyAppLinking();
  //   return appLinking.linkSubscription;
  // }

  // static MyAppLinking get instance {
  //   return _instance;
  // }

  // static MyAppLinking get appLinking {
  //   return _instance;
  // }

  // static void init() {
  //   _instance.init();
  // }

  // static void dispose() {
  //   _instance.dispose();
  // }

  // static void open(Uri uri) {
  //   _instance.openAppLink(uri);
  // }

  // static GlobalKey<NavigatorState> get key {
  //   return _instance.navigatorKey;
  // }

  // static StreamSubscription<Uri>? get subscription {
  //   return _instance.linkSubscription;
  // }

  // static void initAppLinking() {
  //   _instance.init();
  // }

  // static void disposeAppLinking() {
  //   _instance.dispose();
  // }

  // static void openAppLink(Uri uri) {
  //   _instance.openAppLink(uri);
  // }

  // static GlobalKey<NavigatorState> get navigator {
  //   return _instance.navigatorKey;
  // }

  // static StreamSubscription<Uri>? get link {
  //   return _instance.linkSubscription;
  // }

  // static MyAppLinking get appLinkingInstance {
  //   return _instance;
  // }
}
