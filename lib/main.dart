import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/dashboard/views/screens/sign_in_screen.dart';
import 'routes/app_linking.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppNavigator().init();
  // await dotenv.load(fileName: kDebugMode ? 'dev.env' : 'prod.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sellout',
      navigatorKey: AppNavigator().navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: (RouteSettings settings) {
        
      },
      // initialRoute: DashboardScreen.routeName,
    );
  }
}
