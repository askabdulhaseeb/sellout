import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/sockets/socket_service.dart';
import 'core/theme/app_theme.dart';
import 'services/app_providers.dart';
import 'core/sources/local/hive_db.dart';
import 'core/utilities/app_localization.dart';
import 'services/get_it.dart';
import 'routes/app_linking.dart';
import 'routes/app_routes.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppNavigator().init();
  await HiveDB.init();
  await dotenv.load(fileName: kDebugMode ? 'dev.env' : 'prod.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();
  setupLocator();
  await EasyLocalization.ensureInitialized();
  SocketService(locator()).initAndListen();
  runApp(EasyLocalization(
    supportedLocales: const <Locale>[AppLocalization.en],
    path: AppLocalization.filePath,
    fallbackLocale: AppLocalization.defaultLocale,
    startLocale: AppLocalization.defaultLocale,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        // onGenerateRoute: (RouteSettings settings) {},
        //initialRoute: SignupScreen.routeName,
      ),
    );
  }
}
