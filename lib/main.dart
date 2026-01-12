import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/sockets/socket_service.dart';
import 'core/theme/app_theme.dart';
import 'services/app_data_service.dart';
import 'services/app_providers.dart';
import 'services/system_notification_service.dart';
import 'core/sources/local/hive_db.dart';
import 'core/utilities/app_localization.dart';
import 'services/get_it.dart';
import 'routes/app_linking.dart';
import 'routes/app_routes.dart';
import 'services/firebase_messaging_service.dart';

/// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  AppNavigator().init();
  await HiveDB.init();
  await dotenv.load(fileName: kDebugMode ? 'dev.env' : 'prod.env');

  // Initialize Firebase
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();
  setupLocator();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[AppLocalization.en],
      path: AppLocalization.filePath,
      fallbackLocale: AppLocalization.defaultLocale,
      startLocale: AppLocalization.defaultLocale,
      child: const MyApp(),
    ),
  );
  // Remove splash and defer non-critical initializations until after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    FlutterNativeSplash.remove();
    await SystemNotificationService().init();
    await FirebaseMessagingService().init();
    SocketService(locator()).initAndListen();
    AppDataService().fetchAllData();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Assume app is foreground on start; will be updated on lifecycle events.
    SystemNotificationService().setAppInForeground(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bool isForeground = state == AppLifecycleState.resumed;
    SystemNotificationService().setAppInForeground(isForeground);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: 'Sellout',
        navigatorKey: AppNavigator().navigatorKey,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
      ),
    );
  }
}
