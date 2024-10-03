import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app_providers.dart';
import 'core/utilities/app_localization.dart';
import 'routes/app_linking.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  AppNavigator().init();
  await dotenv.load(fileName: kDebugMode ? 'dev.env' : 'prod.env');
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
    const Color primaryColor = Color(0xFFBF1017);
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: 'Sellout',
        navigatorKey: AppNavigator().navigatorKey,
        theme: ThemeData(
          primaryColor: primaryColor,
          shadowColor: Colors.black.withOpacity(0.2),
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        routes: AppRoutes.routes,
        // onGenerateRoute: (RouteSettings settings) {},
        // initialRoute: DashboardScreen.routeName,
      ),
    );
  }
}
