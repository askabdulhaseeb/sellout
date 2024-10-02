import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppNavigator {
  // Variables
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();

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
    log('Moving to $routeName');
    await pushNamed(routeName);
  }

  Future<void> pushNamed(String routeName, {Object? arguments}) async {
    try {
      await _navigatorKey.currentState
          ?.pushNamed(routeName, arguments: arguments);
    } catch (e) {
      log('❌ Error in App Navigator - pushNamed: $routeName - Error: $e');
    }
  }

  Future<void> pushNamedAndRemoveUntil(
    String routeName, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) async {
    try {
      log('New Path is: $routeName');
      final Object? result =
          await _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        predicate ?? (_) => true,
        arguments: arguments,
      );
      log('Result: $result');
    } catch (e) {
      log('❌ Error in App Navigator - pushNamedAndRemoveUntil: $routeName - Error: $e');
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
